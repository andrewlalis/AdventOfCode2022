module s2b;
import util;

void main() {
    readText("input/2.txt").strip.splitter("\n")
        .map!(l => l.strip.splitter(" ").map!(c => c.to!char).array)
        .map!((c) {
            int sOp = c[0] - 'A' + 1;
            int sEnd = c[1];
            if (sEnd == 'X') {
                int sMe = sOp - 1;
                if (sMe < 1) sMe = 3;
                return sMe;
            }
            if (sEnd == 'Z') {
                int sMe = sOp + 1;
                if (sMe > 3) sMe = 1;
                return 6 + sMe;
            }
            return 3 + sOp;
        })
        .sum.writeln;
}
