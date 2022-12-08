module s8a;
import util;

void main() {
    ubyte[][] heightmap = readText("input/8.txt").strip.splitter("\n")
        .map!(s => s.map!(c => cast(ubyte)(c.to!int - '0')).array)
        .array;
    int width = heightmap[0].length.to!int;
    int height = heightmap.length.to!int;
    ulong visibleCount = 2 * height + 2 * (width - 2);
    for (int y = 1; y < height - 1; y++) {
        for (int x = 1; x < width - 1; x++) {
            ubyte tree = heightmap[y][x];
            if (isVisible(tree, x, y, heightmap)) visibleCount++;
        }
    }
    writeln(visibleCount);
}

bool isVisible(ubyte tree, int tx, int ty, ubyte[][] heightmap) {
    // Check top:
    bool visible = true;
    for (int y = 0; y < ty; y++) {
        if (heightmap[y][tx] >= tree) {
            visible = false;
            break;
        }
    }
    if (visible) return true;
    visible = true;
    // bottom:
    for (int y = ty + 1; y < heightmap.length; y++) {
        if (heightmap[y][tx] >= tree) {
            visible = false;
            break;
        }
    }
    if (visible) return true;
    visible = true;
    // left:
    for (int x = 0; x < tx; x++) {
        if (heightmap[ty][x] >= tree) {
            visible = false;
            break;
        }
    }
    // right:
    if (visible) return true;
    visible = true;
    for (int x = tx + 1; x < heightmap[0].length; x++) {
        if (heightmap[ty][x] >= tree) {
            visible = false;
            break;
        }
    }
    return visible;
}