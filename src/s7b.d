module s7a;
import util;

void main() {
    string[] output = readText("input/7.txt").strip().splitter("\n").array;
    FsNode root = new FsNode();
    root.parent = null;
    root.name = "/";
    root.dir = true;
    FsNode currentNode = null;
    for (int i = 0; i < output.length; i++) {
        string line = output[i];
        if (line.startsWith("$")) {
            string cmd, arg;
            formattedRead(line[2..$], "%s %s", cmd, arg);
            if (cmd == "cd") {
                if (arg == "/") {
                    currentNode = root;
                } else if (arg == ".." && currentNode !is null && currentNode.parent !is null) {
                    currentNode = currentNode.parent;
                } else {
                    foreach (node; currentNode.children) {
                        if (node.name == arg && node.dir) {
                            currentNode = node;
                            break;
                        }
                    }
                }
            } else if (cmd == "ls") {
                if (currentNode.children.length == 0) {
                    for (int j = i + 1; j < output.length; j++) {
                        string resultLine = output[j];
                        if (resultLine.startsWith("$")) break;
                        string a, b;
                        formattedRead(resultLine, "%s %s", a, b);
                        FsNode node = new FsNode();
                        node.name = b;
                        node.parent = currentNode;
                        if (a == "dir") {
                            node.dir = true;
                        } else {
                            node.dir = false;
                            node.size = a.to!ulong;
                            FsNode dir = currentNode;
                            while (dir !is null) {
                                dir.size += node.size;
                                dir = dir.parent;
                            }
                        }
                        currentNode.children ~= node;
                    }
                }
            }
        }
    }
    ulong spaceAvailable = 70_000_000;
    ulong spaceUsed = root.size;
    ulong unusedSpace = spaceAvailable - spaceUsed;
    ulong requiredUnusedSpace = 30_000_000;
    ulong spaceToFree = requiredUnusedSpace - unusedSpace;
    writefln!"Used %d out of %d. %d free. Need %d free. Looking for %d of free space"(spaceUsed, spaceAvailable, unusedSpace, requiredUnusedSpace, spaceToFree);
    FsNode[] candidateDirs = findDirs(root, spaceToFree);
    candidateDirs.sort!((a, b) => a.size < b.size);
    foreach (dir; candidateDirs) {
        writefln!"%s, %d"(dir.name, dir.size);
    }
    writeln(candidateDirs[0].size);
}

FsNode[] findDirs(FsNode root, ulong minSize) {
    FsNode[] nodes;
    foreach (child; root.children) {
        if (child.dir) {
            if (child.size >= minSize) nodes ~= child;
            nodes ~= findDirs(child, minSize);
        }
    }
    return nodes;
}



class FsNode {
    FsNode parent;
    FsNode[] children;
    string name;
    ulong size;
    bool dir;

    string absPath() {
        FsNode current = this.parent;
        string path = name;
        while (current !is null) {
            path = current.name ~ "/" ~ path;
            current = current.parent;
        }
        return path;
    }

    void writeTree(int level = 0) {
        for (int i = 0; i < level * 2; i++) {
            write(' ');
        }
        if (dir) {
            writefln!"%s/, total size %d"(name, size);
        } else {
            writefln!"%s, size %d"(name, size);
        }
        foreach (node; children) {
            node.writeTree(level + 1);
        }
    }
}
