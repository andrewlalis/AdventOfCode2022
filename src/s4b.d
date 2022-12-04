module s4b;
import util;

void main() {
    readText("input/4sample.txt").strip.splitter("\n")
        .count!((line) {
            int a, b, c, d;
            formattedRead(line.strip, "%d-%d,%d-%d", a, b, c, d);
            return (a <= d && c <= b);
        })
        .writeln;
}
