# Fix Instructions for Implementer Agent

## Bug Description

The `src/app.js` file contains THREE bugs in an e-commerce cart calculation module:

1. **calculateTotal()** - Off-by-one error: The loop condition `i < items.length - 1` skips the last item
2. **applyDiscount()** - Wrong formula: Uses addition instead of subtraction when applying discount
3. **validateCart()** - Logic error: Uses `>= 0` instead of `> 0`

## Fix Steps

1. **Fix calculateTotal()**
   - Change loop condition from `i < items.length - 1` to `i < items.length`

2. **Fix applyDiscount()**
   - Change `total + (total * discountPercent / 100)` to `total - (total * discountPercent / 100)`

3. **Fix validateCart()**
   - Change condition from `items.length >= 0` to `items.length > 0`

## Verification

Run `node tests/app.test.js` to verify all tests pass.
Expected result: All 6 tests should pass.