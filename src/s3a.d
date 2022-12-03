module s3a;
import util;

void main() {
    readText("input/3.txt").strip.splitter("\n")
        .map!(line => [
            Set!char(line[0 .. $ / 2].to!(char[])),
            Set!char(line[$ / 2 .. $].to!(char[]))
        ])
        .map!(sets => sets[0].intersectWith(sets[1]).items[0])
        .map!(c => c.isUpper ? c - 'A' + 27 : c - 'a' + 1)
        .sum.writeln;
}
