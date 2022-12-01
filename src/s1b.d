module s1b;
import util;

void main() {
    readText("input/1.txt").strip.splitter("\n\n")
        .map!(c => c.strip.splitter("\n").map!(l => l.to!ulong).sum)
        .array.topN!((a, b) => a > b)(3).sum.writeln;
}
