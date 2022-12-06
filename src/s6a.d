module s6a;
import util;

void main() {
    string code = readText("input/6.txt").strip();
    for (int i = 0; i < code.length; i++) {
        if (i >= 3 && Set!char(code[i - 3 .. i + 1].to!(char[])).items.length == 4) {
            writeln(i + 1);
            break;
        }
    }
}
