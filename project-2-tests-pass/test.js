const { add, multiply } = require("./app");

let passed = 0;
let failed = 0;

function test(name, actual, expected) {
    if (actual === expected) {
        console.log(`PASS: ${name}`);
        passed++;
    } else {
        console.log(`FAIL: ${name} | Expected ${expected}, got ${actual}`);
        failed++;
    }
}

test("add 2 + 3", add(2, 3), 5);
test("add 10 + 5", add(10, 5), 15);
test("multiply 3 * 4", multiply(3, 4), 12);

console.log(`\nPassed: ${passed}`);
console.log(`Failed: ${failed}`);

process.exit(failed > 0 ? 1 : 0);