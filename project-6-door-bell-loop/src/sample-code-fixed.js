/**
 * Fixed sample code for automated PR review testing
 * Fix: Correct loop condition in calculateSum to prevent array out of bounds
 */

/**
 * Calculate the sum of all numbers in an array
 * @param {number[]} array - Array of numbers to sum
 * @returns {number} Sum of all numbers
 */
function calculateSum(array) {
  if (!array || array.length === 0) {
    return 0;
  }

  let sum = 0;

  // FIXED: Loop condition uses < instead of <=
  for (let i = 0; i < array.length; i++) {
    sum += array[i];
  }

  return sum;
}

/**
 * Find the maximum value in an array
 * @param {number[]} array - Array of numbers
 * @returns {number} Maximum value
 */
function findMax(array) {
  if (!array || array.length === 0) {
    return null;
  }

  let max = array[0];
  for (let i = 1; i < array.length; i++) {
    if (array[i] > max) {
      max = array[i];
    }
  }

  return max;
}

/**
 * Calculate average of numbers in an array
 * @param {number[]} array - Array of numbers
 * @returns {number} Average value
 */
function calculateAverage(array) {
  if (!array || array.length === 0) {
    return 0;
  }

  const sum = calculateSum(array);
  return sum / array.length;
}

module.exports = {
  calculateSum,
  findMax,
  calculateAverage
};
