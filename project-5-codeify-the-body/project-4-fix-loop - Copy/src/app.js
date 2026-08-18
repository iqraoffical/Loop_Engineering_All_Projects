// DELIBERATELY BROKEN VERSION for testing FAIL scenario
// This version has INCORRECT fixes to test that the reviewer catches bad fixes

function calculateTotal(items) {
  // WRONG FIX: Changed loop but still wrong logic
  let total = 0;
  for (let i = 0; i < items.length; i++) {
    total += items[i].price * items[i].quantity;
  }
  return total;
}

function applyDiscount(total, discountPercent) {
  // WRONG FIX: Still using addition
  return total - (total * discountPercent / 100);
}

function validateCart(items) {
  // WRONG FIX: Still accepts empty carts
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
