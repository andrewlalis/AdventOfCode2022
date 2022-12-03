module s3b;
import util;

void main() {
    auto sets = readText("input/3.txt").strip.splitter("\n")
        .map!(line => Set!char(line.to!(char[]))).array;
    ulong sum = 0;
    for (int i = 0; i < sets.length / 3; i++) {
        char c = sets[i * 3]
            .intersectWith(sets[i * 3 + 1])
            .intersectWith(sets[i * 3 + 2])
            .items[0];
        sum += c.isUpper ? c - 'A' + 27 : c - 'a' + 1;
    }
    sum.writeln;
}