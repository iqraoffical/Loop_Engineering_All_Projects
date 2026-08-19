/**
 * Sample code with a planted bug for automated PR review testing
 * Bug type: Off-by-one error in array iteration
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

  // BUG: This loop has an off-by-one error
  // Should be i < array.length, not i <= array.length
  for (let i = 0; i <= array.length; i++) {
    sum += array[i];  // This will access undefined on the last iteration
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

  const sum = calculateSum(array);  // This will be incorrect due to the bug
  return sum / array.length;
}

module.exports = {
  calculateSum,
  findMax,
  calculateAverage
};
