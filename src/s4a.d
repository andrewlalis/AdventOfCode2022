module s4a;
import util;

void main() {
    readText("input/4.txt").strip.splitter("\n")
        .count!((line) {
            int a, b, c, d;
            formattedRead(line.strip, "%d-%d,%d-%d", a, b, c, d);
            return (a >= c && b <= d) || (c >= a && d <= b);
        })
        .writeln;
}
