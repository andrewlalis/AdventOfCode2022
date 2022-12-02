module s2a;
import util;

void main() {
    readText("input/2.txt").strip.splitter("\n")
        .map!(l => l.strip.splitter(" ").map!(c => c.to!char).array)
        .map!((c) {
            int sOp = c[0] - 'A' + 1;
            int sMe = c[1] - 'X' + 1;
            if (sMe == sOp % 3 + 1) return 6 + sMe;
            if (sOp == sMe % 3 + 1) return sMe;
            return 3 + sMe;
        })
        .sum.writeln;
}
