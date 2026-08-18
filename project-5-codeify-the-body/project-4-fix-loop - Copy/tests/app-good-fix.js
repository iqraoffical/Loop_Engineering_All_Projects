// CORRECT VERSION for testing PASS scenario
// This version has all bugs fixed correctly

function calculateTotal(items) {
  // FIXED: Changed loop condition to include all items
  let total = 0;
  for (let i = 0; i < items.length; i++) {
    total += items[i].price * items[i].quantity;
  }
  return total;
}

function applyDiscount(total, discountPercent) {
  // FIXED: Changed to subtraction
  return total - (total * discountPercent / 100);
}

function validateCart(items) {
  // FIXED: Changed to reject empty carts
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
