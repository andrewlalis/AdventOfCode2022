module s11a;
import util;

import std.bigint;

void main() {
    Monkey[] monkeys = readText("input/11sample.txt").strip.splitter("\n\n")
        .map!(parseMonkey).array;
    
    for (int i = 0; i < 10_000; i++) {
        writefln!"Round %d"(i + 1);
        for (int mId = 0; mId < monkeys.length; mId++) {
            Monkey* m = &monkeys[mId];
            while (m.items.length > 0) {
                BigInt item = m.items[0];
                m.items = m.items.remove(0);
                
                char op = m.operation[0];
                string argS = m.operation[1];
                BigInt arg = argS == "old" ? item : argS.to!BigInt;
                BigInt newValue;
                if (op == '+') newValue = item + arg;
                if (op == '*') newValue = item * arg;

                if (newValue % m.testDivisor == 0) {
                    monkeys[m.testTrueMonkeyId].items ~= newValue;
                } else {
                    monkeys[m.testFalseMonkeyId].items ~= newValue;
                }
                m.inspections++;
            }
        }
        if ((i + 1) % 1000 == 0) {
            writefln!"== After round %d =="(i + 1);
            for (int mId = 0; mId < monkeys.length; mId++) {
                writefln!"Monkey %d inspected items %d times."(mId, monkeys[mId].inspections);
                writeln(monkeys[mId].items);
            }
        }
    }

    ulong[] topValues = monkeys.map!(m => m.inspections).array.topN!"a > b"(2UL);
    ulong monkeyBusiness = reduce!"a * b"(1UL, topValues);
    writeln(monkeyBusiness);
}

struct Monkey {
    BigInt[] items;
    Tuple!(char, string) operation;
    int testDivisor;
    int testTrueMonkeyId;
    int testFalseMonkeyId;
    ulong inspections;
}

Monkey parseMonkey(string s) {
    string[] lines = s.splitter("\n").array;
    Monkey m;
    m.items = lines[1][18..$].splitter(", ").map!(s => s.to!BigInt).array;
    m.operation = Tuple!(char, string)(lines[2][23], lines[2][25..$]);
    m.testDivisor = lines[3][21..$].to!int;
    m.testTrueMonkeyId = lines[4][29..$].to!int;
    m.testFalseMonkeyId = lines[5][30..$].to!int;
    return m;
}
