#!/usr/bin/env rdmd

/**
 * Simple wrapper program for managing the various solutions. Each solution is
 * defined as a single D source file in `src/s\d+[a-z]*.d`, which is an "s"
 * followed by the day number, followed by a character representing which
 * challenge of the day it is.
 *
 * This script can be executed standalone via `./runner.d`, provided that you
 * have given the script the execution privilege (usually with `chmod +x runner.d`).
 *
 * It offers the following capabilities:
 * - `./runner.d clean` removes all compiled binaries.
 * - `./runner.d run [all | solution...]` Runs one or more solutions.
 * - `./runner.d create <solutionName>` Creates a new solution source file.
 */
module runner;

import std.stdio;
import std.string;
import std.process;
import std.file;
import std.path;
import std.regex;
import std.algorithm;
import std.digest.md;
import std.base64;

int main(string[] args) {
    if (args.length < 2) {
        // By default, run the script with different behavior depending on what's available.
        string[] runArgs = [];
        string lastSolutionFilePath = buildPath("bin", "last-solution.txt");
        if (exists(lastSolutionFilePath)) {
            string solution = readText(lastSolutionFilePath).strip();
            if (exists(buildPath("bin", solution)) && exists(buildPath("src", solution ~ ".d"))) {
                writeln("Running the last solution that was previously ran.");
                runArgs = [solution];
            }
        }
        return run(runArgs);
    } else {
        string command = args[1].strip().toLower();
        if (command == "clean") {
            clean();
            return 0;
        } else if (command == "run") {
            return run(args[2 .. $]);
        } else if (command == "create") {
            return create(args[2 .. $]);
        } else {
            writefln!"Unknown command: \"%s\". Should be one of: clean | run [solution...]"(command);
            return 1;
        }
    }
}

/** 
 * Removes all files from the `bin/` directory, which forces recompilation of
 * any solutions.
 */
void clean() {
    if (!exists("bin")) return;
    foreach (entry; dirEntries("bin", SpanMode.shallow, false)) {
        if (isFile(entry.name)) {
            writefln!"Removing file %s"(entry.name);
            std.file.remove(entry.name);
        } else if (isDir(entry.name)) {
            writefln!"Removing directory %s"(entry.name);
            rmdirRecurse(entry.name);
        }
    }
}

/** 
 * Runs one or more solutions, compiling them if needed.
 * Params:
 *   args = The arguments provided to this command.
 * Returns: A program exit code.
 */
int run(string[] args) {
    string[] solutionsToRun;
    if (args.length == 0 || args[0].strip().toLower() == "all") {
        auto r = ctRegex!(`^(s\d+[a-z]*)\.d$`);
        foreach (entry; dirEntries("src", SpanMode.shallow, false)) {
            auto c = matchFirst(baseName(entry.name), r);
            if (c) solutionsToRun ~= c[1];
        }
    } else {
        foreach (arg; args) {
            string solutionName = arg;
            if (!solutionName.startsWith("s")) solutionName = "s" ~ solutionName;
            if (solutionName.endsWith(".d")) solutionName = solutionName[0 .. $ - 2];
            string filePath = buildPath("src", solutionName ~ ".d");
            if (!exists(filePath)) {
                writefln!"The solution at %s doesn't exist."(filePath);
                return 1;
            }
            solutionsToRun ~= solutionName;
        }
    }
    if (solutionsToRun.length == 0) {
        writeln("No solutions to run.");
        return 0;
    }
    solutionsToRun.sort();
    foreach (solution; solutionsToRun) {
        bool canRun = true;
        if (isSolutionRecompileNeeded(solution)) {
            writefln!"Recompiling solution %s..."(solution);
            int result = compileSolution(solution);
            if (result != 0) canRun = false;
        }
        if (canRun) {
            runSolution(solution);
        }
    }
    return 0;
}

/** 
 * Checks if a solution needs to be (re)compiled before it's run. This is the
 * case when the executable doesn't exist, or the hash of the solution source
 * doesn't match the hash of the current source.
 * Params:
 *   solution = The solution to check.
 * Returns: True if we should recompile the solution.
 */
bool isSolutionRecompileNeeded(string solution) {
    string solutionFilePath = buildPath("src", solution ~ ".d");
    string hashFilePath = buildPath("bin", solution ~ "-hash.md5");
    string executablePath = buildPath("bin", solution);
    if (!exists(hashFilePath) || !exists(executablePath)) return true;
    ubyte[] storedHash = Base64.decode(readText(hashFilePath).strip());
    ubyte[16] currentHash = md5Of(readText(solutionFilePath));
    return storedHash != currentHash;
}

/** 
 * Compiles a solution using `dmd`, and includes an MD5 hash of the source in
 * the `bin/` directory alongside the executable.
 * Params:
 *   solution = The solution to compile.
 * Returns: 0 on success, or 1 on failure.
 */
int compileSolution(string solution) {
    string solutionFilePath = buildPath("src", solution ~ ".d");
    string hashFilePath = buildPath("bin", solution ~ "-hash.md5");
    if (!exists("bin")) mkdir("bin");
    ubyte[16] hash = md5Of(readText(solutionFilePath));
    std.file.write(hashFilePath, Base64.encode(hash));
    string utilFilePath = buildPath("src", "util.d");
    string outputFilePath = buildPath("bin", solution);
    string cmd = format!"dmd %s %s -inline -O -of=%s"(utilFilePath, solutionFilePath, outputFilePath);
    auto result = executeShell(cmd);
    if (result.status != 0) {
        writefln!"Failed to compile solution %s, exit code %d:\n%s"(solution, result.status, result.output);
        return 1;
    }
    return 0;
}

/** 
 * Executes a solution, using this script's current working directory as the
 * directory for the process, and inheriting all IO streams.
 * Params:
 *   solution = The solution to run.
 */
void runSolution(string solution) {
    string processPath = buildPath("bin", solution);
    writefln!"-----< %s >-----"(solution);
    Pid pid = spawnProcess(processPath);
    int result = wait(pid);
    writeln();
    if (result != 0) {
        writefln!"Solution %s failed with exit code %d."(solution, result);
    }
    std.file.write(buildPath("bin", "last-solution.txt"), solution);
}

/** 
 * Creates a new solution source file.
 * Params:
 *   args = The command line arguments.
 * Returns: An exit code.
 */
int create(string[] args) {
    if (args.length < 1) {
        writeln("Missing required solution name.");
        return 1;
    }
    string solution = args[0].strip().toLower();
    auto r = ctRegex!(`^s\d+[a-z]*$`);
    auto c = matchFirst(solution, r);
    if (!c) {
        writefln!"Solution name \"%s\" is not valid. Should be \"s\\d+[a-z]*\"."(solution);
        return 1;
    }
    string filePath = buildPath("src", solution ~ ".d");
    bool force = args.length >= 2 && args[1].strip().toLower() == "-f";
    if (exists(filePath) && !force) {
        writefln!"Solution \"%s\" already exists."(solution);
        return 1;
    }
    File f = File(filePath, "w");
    f.writefln!"module %s;"(solution);
    f.writeln("import util;");
    f.writeln();
    f.writefln!"void main(string[] args) {\n    writeln(\"Hello from %s\");\n}"(solution);
    f.close();
    return 0;
}