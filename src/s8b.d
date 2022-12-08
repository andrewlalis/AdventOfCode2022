module s8b;
import util;

void main() {
    ubyte[][] heightmap = readText("input/8.txt").strip.splitter("\n")
        .map!(s => s.map!(c => cast(ubyte)(c.to!int - '0')).array)
        .array;
    int width = heightmap[0].length.to!int;
    int height = heightmap.length.to!int;
    ulong maxScore = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            ulong score = computeScore(x, y, heightmap);
            if (score > maxScore) maxScore = score;
        }
    }
    writeln(maxScore);
}

ulong computeScore(int tx, int ty, ubyte[][] heightmap) {
    ubyte tree = heightmap[ty][tx];
    ulong up, down, left, right;
    for (int y = ty - 1; y >= 0; y--) {
        up++;
        if (heightmap[y][tx] >= tree) break;
    }
    for (int y = ty + 1; y < heightmap.length; y++) {
        down++;
        if (heightmap[y][tx] >= tree) break;
    }
    for (int x = tx - 1; x >= 0; x--) {
        left++;
        if (heightmap[ty][x] >= tree) break;
    }
    for (int x = tx + 1; x < heightmap[0].length; x++) {
        right++;
        if (heightmap[ty][x] >= tree) break;
    }
    return up * down * left * right;
}
