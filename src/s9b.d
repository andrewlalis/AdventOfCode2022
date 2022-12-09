module s9b;
import util;

struct Vec2 {
    int x;
    int y;
}

void main() {
    string[] commands = readText("input/9.txt").strip.splitter("\n").array;
    Set!Vec2 visited = Set!Vec2([]);
    Vec2[10] rope;
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
            rope[0].x += dirVec.x;
            rope[0].y += dirVec.y;
            for (int r = 0; r + 1 < rope.length; r++) {
                Vec2* head = &rope[r];
                Vec2* tail = &rope[r + 1];
                int distX = head.x - tail.x;
                int distY = head.y - tail.y;
                if (abs(distX) > 1 || abs(distY) > 1) {
                    if (distX == 0 || distY == 0) {
                        if (head.x > tail.x) tail.x++;
                        if (head.x < tail.x) tail.x--;
                        if (head.y > tail.y) tail.y++;
                        if (head.y < tail.y) tail.y--;
                    } else {
                        tail.x += distX > 0 ? 1 : -1;
                        tail.y += distY > 0 ? 1 : -1;
                    }
                }
                if (r + 2 == rope.length) visited.add(*tail);
            }
        }
    }
    writeln(visited.items.length);
}
