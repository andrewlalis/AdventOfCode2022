module s11a;
import util;

void main() {
    Monkey[] monkeys = readText("input/11.txt").strip.splitter("\n\n")
        .map!(parseMonkey).array;
    
    for (int i = 0; i < 20; i++) {
        for (int mId = 0; mId < monkeys.length; mId++) {
            Monkey* m = &monkeys[mId];
            while (m.items.length > 0) {
                int item = m.items[0];
                m.items = m.items.remove(0);
                
                char op = m.operation[0];
                string argS = m.operation[1];
                int arg = argS == "old" ? item : argS.to!int;
                int newValue;
                if (op == '+') newValue = item + arg;
                if (op == '*') newValue = item * arg;

                newValue /= 3;

                if (newValue % m.testDivisor == 0) {
                    monkeys[m.testTrueMonkeyId].items ~= newValue;
                } else {
                    monkeys[m.testFalseMonkeyId].items ~= newValue;
                }
                m.inspections++;
            }
        }
    }

    int[] topValues = monkeys.map!(m => m.inspections).array.topN!"a > b"(2);
    int monkeyBusiness = reduce!"a * b"(1, topValues);
    writeln(monkeyBusiness);
}

struct Monkey {
    int[] items;
    Tuple!(char, string) operation;
    int testDivisor;
    int testTrueMonkeyId;
    int testFalseMonkeyId;
    int inspections;
}

Monkey parseMonkey(string s) {
    string[] lines = s.splitter("\n").array;
    Monkey m;
    m.items = lines[1][18..$].splitter(", ").map!(s => s.to!int).array;
    m.operation = Tuple!(char, string)(lines[2][23], lines[2][25..$]);
    m.testDivisor = lines[3][21..$].to!int;
    m.testTrueMonkeyId = lines[4][29..$].to!int;
    m.testFalseMonkeyId = lines[5][30..$].to!int;
    return m;
}
