module s6b;
import util;

void main() {
    string code = readText("input/6.txt").strip();
    for (int i = 0; i < code.length; i++) {
        if (i >= 13 && Set!char(code[i - 13 .. i + 1].to!(char[])).items.length == 14) {
            writeln(i + 1);
            break;
        }
    }
}
