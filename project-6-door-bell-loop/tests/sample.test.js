/**
 * Tests for sample-code.js
 * Note: These tests will fail due to the planted bug
 */

const { calculateSum, findMax, calculateAverage } = require('../src/sample-code');

describe('calculateSum', () => {
  test('should sum an array of positive numbers', () => {
    expect(calculateSum([1, 2, 3, 4, 5])).toBe(15);
  });

  test('should handle empty array', () => {
    expect(calculateSum([])).toBe(0);
  });

  test('should handle single element', () => {
    expect(calculateSum([42])).toBe(42);
  });

  test('should handle negative numbers', () => {
    expect(calculateSum([-1, -2, -3])).toBe(-6);
  });
});

describe('findMax', () => {
  test('should find maximum in array', () => {
    expect(findMax([1, 5, 3, 9, 2])).toBe(9);
  });

  test('should handle single element', () => {
    expect(findMax([42])).toBe(42);
  });

  test('should handle negative numbers', () => {
    expect(findMax([-5, -1, -10])).toBe(-1);
  });

  test('should return null for empty array', () => {
    expect(findMax([])).toBe(null);
  });
});

describe('calculateAverage', () => {
  test('should calculate average correctly', () => {
    expect(calculateAverage([1, 2, 3, 4, 5])).toBe(3);
  });

  test('should handle empty array', () => {
    expect(calculateAverage([])).toBe(0);
  });

  test('should handle single element', () => {
    expect(calculateAverage([10])).toBe(10);
  });
});
