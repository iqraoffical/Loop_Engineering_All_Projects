const { calculateTotal, applyDiscount, validateCart } = require('../src/app.js');

let passed = 0;
let failed = 0;

function test(description, actual, expected) {
  if (JSON.stringify(actual) === JSON.stringify(expected)) {
    console.log(`✓ PASS: ${description}`);
    passed++;
  } else {
    console.log(`✗ FAIL: ${description}`);
    console.log(`  Expected: ${JSON.stringify(expected)}`);
    console.log(`  Got: ${JSON.stringify(actual)}`);
    failed++;
  }
}

// Test calculateTotal
const cart1 = [
  { price: 10, quantity: 2 },
  { price: 5, quantity: 1 },
  { price: 15, quantity: 3 }
];
test('calculateTotal with 3 items', calculateTotal(cart1), 70);

const cart2 = [
  { price: 20, quantity: 1 }
];
test('calculateTotal with 1 item', calculateTotal(cart2), 20);

// Test applyDiscount
test('applyDiscount 10% off $100', applyDiscount(100, 10), 90);
test('applyDiscount 25% off $200', applyDiscount(200, 25), 150);

// Test validateCart
test('validateCart with items', validateCart([{ price: 10, quantity: 1 }]), true);
test('validateCart with empty cart', validateCart([]), false);

console.log('\n==============================');
console.log(`Passed: ${passed}`);
console.log(`Failed: ${failed}`);
console.log('==============================');

process.exit(failed > 0 ? 1 : 0);