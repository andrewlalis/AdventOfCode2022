module s10a;
import util;

void main() {
    string[] commands = readText("input/10.txt").strip.splitter("\n").array;
    int x = 1;
    size_t commandIdx = 0;
    size_t crtIdx = 0;
    char[] crtRow;
    while (commandIdx < commands.length) {
        string command = commands[commandIdx++];
        drawCrt(crtIdx, crtRow, x);
        if (command.startsWith("addx")) {
            drawCrt(crtIdx, crtRow, x);
            x += command[5..$].to!int;
        }
    }
}

void drawCrt(ref size_t crtIdx, ref char[] crtRow, int x) {
    bool lit = x == crtIdx - 1 || x == crtIdx || x == crtIdx + 1;
    crtRow ~= lit ? '#' : '.';
    crtIdx++;
    if (crtIdx > 39) {
        crtIdx = 0;
        writeln(crtRow);
        crtRow.length = 0;
    }
}
