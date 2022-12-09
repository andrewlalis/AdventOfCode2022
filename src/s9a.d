module s9a;
import util;

struct Vec2 {
    int x;
    int y;
}

void main() {
    string[] commands = readText("input/9.txt").strip.splitter("\n").array;
    Vec2 head;
    Vec2 tail;
    Set!Vec2 visited = Set!Vec2([]);
    foreach (command; commands) {
        char direction;
        int amount;
        formattedRead(command, "%c %d", direction, amount);
        Vec2 dirVec;
        if (direction == 'U') {
            dirVec = Vec2(0, 1);
        } else if (direction == 'D') {
            dirVec = Vec2(0, -1);
        } else if (direction == 'R') {
            dirVec = Vec2(1, 0);
        } else {
            dirVec = Vec2(-1, 0);
        }
        for (int i = 0; i < amount; i++) {
            Vec2 prevHeadPos = head;
            head.x += dirVec.x;
            head.y += dirVec.y;
            int distX = abs(head.x - tail.x);
            int distY = abs(head.y - tail.y);
            if (distX > 1 || distY > 1) {
                if (distX == 0 || distY == 0) {
                    if (head.x > tail.x) tail.x++;
                    if (head.x < tail.x) tail.x--;
                    if (head.y > tail.y) tail.y++;
                    if (head.y < tail.y) tail.y--;
                } else {
                    tail.x = prevHeadPos.x;
                    tail.y = prevHeadPos.y;
                }
            }
            visited.add(tail);
        }
    }
    writeln(visited.items.length);
}
