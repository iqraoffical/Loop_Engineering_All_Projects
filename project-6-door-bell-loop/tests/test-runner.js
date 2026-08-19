/**
 * Standalone Test Runner for Project 6: Door Bell Loop
 * Runs without requiring npm / jest dependencies.
 */

const { calculateSum, findMax, calculateAverage } = require('../src/sample-code');

let passed = 0;
let failed = 0;

function assertEqual(actual, expected, testName) {
  if (actual === expected || (isNaN(actual) && isNaN(expected))) {
    if (actual === expected) {
      console.log(`  [PASS] ${testName}`);
      passed++;
      return;
    }
  }
  console.log(`  [FAIL] ${testName}`);
  console.log(`         Expected: ${expected}`);
  console.log(`         Actual:   ${actual}`);
  failed++;
}

console.log('====================================================');
console.log('Project 6 Test Suite: Sample Code Verification');
console.log('====================================================\n');

console.log('--- calculateSum ---');
assertEqual(calculateSum([1, 2, 3, 4, 5]), 15, 'should sum an array of positive numbers');
assertEqual(calculateSum([]), 0, 'should handle empty array');
assertEqual(calculateSum([42]), 42, 'should handle single element');
assertEqual(calculateSum([-1, -2, -3]), -6, 'should handle negative numbers');

console.log('\n--- findMax ---');
assertEqual(findMax([1, 5, 3, 9, 2]), 9, 'should find maximum in array');
assertEqual(findMax([42]), 42, 'should handle single element');
assertEqual(findMax([-5, -1, -10]), -1, 'should handle negative numbers');
assertEqual(findMax([]), null, 'should return null for empty array');

console.log('\n--- calculateAverage ---');
assertEqual(calculateAverage([1, 2, 3, 4, 5]), 3, 'should calculate average correctly');
assertEqual(calculateAverage([]), 0, 'should handle empty array');
assertEqual(calculateAverage([10]), 10, 'should handle single element');

console.log('\n====================================================');
console.log(`Total: ${passed + failed} | Passed: ${passed} | Failed: ${failed}`);
if (failed > 0) {
  console.log('Result: Planted bug detected (calculateSum returns NaN due to off-by-one loop)');
  process.exit(1);
} else {
  console.log('Result: All tests passed cleanly!');
  process.exit(0);
}
