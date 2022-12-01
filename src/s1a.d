module s1a;
import util;

void main() {
    ulong maxCalories = 0;
    ulong currentCalories = 0;
    foreach (line; File("input/1.txt", "r").byLine()) {
        if (line.strip().length == 0) {
            if (currentCalories > maxCalories) maxCalories = currentCalories;
            currentCalories = 0;
        } else {
            currentCalories += line.strip().to!ulong;
        }
    }
    writeln(maxCalories);
}