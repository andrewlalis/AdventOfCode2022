module s1a;
import util;

void main() {
    readText("input/1.txt").strip.splitter("\n\n")
        .map!(c => c.strip.splitter("\n").map!(l => l.to!ulong).sum)
        .maxElement.writeln;
}
