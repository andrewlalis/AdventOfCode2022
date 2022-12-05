module s5a;
import util;

void main() {
    string[] fileContent = readText("input/5.txt").splitter("\n\n").array;
    string stackContent = fileContent[0];
    char[][] stacks = readStacks(stackContent);

    string instructionContent = fileContent[1].strip;
    uint count, origin, dest;
    foreach (instruction; instructionContent.splitter("\n")) {
        formattedRead(instruction, "move %d from %d to %d", count, origin, dest);
        for (int i = 0; i < count; i++) {
            stacks[dest-1] ~= stacks[origin - 1][$ - 1];
            stacks[origin-1] = stacks[origin - 1][0 .. $ - 1];
        }
    }
    writeln(stacks.map!(s => s[$ - 1]).array);
}

char[][] readStacks(string content) {
    char[][] stackArray = content.splitter("\n").array.to!(char[][]);
    ulong width = stackArray[0].length;
    ulong height = stackArray.length;
    char[][] rotatedStackArray;
    rotatedStackArray.length = width;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            if (rotatedStackArray[x].length == 0) rotatedStackArray[x].length = height;
            rotatedStackArray[x][y] = stackArray[y][x];
        }
    }
    for (int x = 0; x < rotatedStackArray.length; x++) {
        rotatedStackArray[x].reverse;
    }
    char[][] stacks;
    foreach (row; rotatedStackArray) {
        if (row.strip.length > 0 && row.strip[0].isNumber) {
            stacks ~= row.strip[1..$];
        }
    }
    return stacks;
}
