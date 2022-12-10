module s10a;
import util;

void main() {
    string[] commands = readText("input/10.txt").strip.splitter("\n").array;
    int x = 1;
    int sum = 0;
    ulong cycleCount = 0;
    size_t commandIdx = 0;
    while (commandIdx < commands.length) {
        string command = commands[commandIdx++];
        checkSignalStrength(cycleCount + 1, x, sum);
        cycleCount++;
        if (command.startsWith("addx")) {
            checkSignalStrength(cycleCount + 1, x, sum);
            x += command[5..$].to!int;
            cycleCount++;
        }
    }
    writeln(sum);
}

void checkSignalStrength(ulong i, int x, ref int sum) {
    if (i == 20 || i == 60 || i == 100 || i == 140 || i == 180 || i == 220) {
        int signalStrength = cast(int) i * x;
        sum += signalStrength;
        writefln!"During cycle %d, x = %d, signal strength: %d"(i, x, signalStrength);
    }
}
