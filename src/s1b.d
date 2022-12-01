module s1b;
import util;

void main() {
    ulong[] top3 = [0, 0, 0];
    ulong currentCalories = 0;
    foreach (line; File("input/1.txt", "r").byLine()) {
        if (line.strip().length == 0) {
            for (int i = 0; i < 2; i++) {
                if (currentCalories > top3[i]) {
                    // Insert current into the top queue, then trim back to size.
                    top3 = top3[0 .. i] ~ currentCalories ~ top3[i .. $];
                    top3 = top3[0 ..3];
                    break;
                }
            }
            currentCalories = 0;
        } else {
            currentCalories += line.strip().to!ulong;
        }
    }
    writeln(top3.sum());
}
