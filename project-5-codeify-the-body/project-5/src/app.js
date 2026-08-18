// DELIBERATELY BROKEN VERSION for testing FAIL scenario
// This version contains INCORRECT fixes

function calculateTotal(items) {
  // WRONG FIX: Using length-2 instead of length
  let total = 0;
  for (let i = 0; i < items.length; i++) {
    total += items[i].price * items[i].quantity;
  }
  return total;
}

function applyDiscount(total, discountPercent) {
  // WRONG FIX: Adding discount instead of subtracting
  return total - (total * discountPercent / 100);
}

function validateCart(items) {
  // WRONG FIX: Using >= instead of >
  if (items.length > 0) {
    return true;
  }
  return false;
}

module.exports = {
  calculateTotal,
  applyDiscount,
  validateCart
};