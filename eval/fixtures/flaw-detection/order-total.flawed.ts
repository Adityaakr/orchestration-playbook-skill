// Flaw-detection fixture (W4-B). This file contains ONE planted subtle flaw.
// Reviewers (fleet vs single-pass) are scored on whether they catch it.
// The flaw + its location is in ../flaw-detection-key.md (do not read before reviewing).

export interface LineItem { priceCents: number; qty: number; }

/** Sum line items and apply a percentage discount. Returns integer cents. */
export function orderTotal(items: LineItem[], discountPercent: number): number {
  let subtotal = 0;
  for (const it of items) {
    subtotal += it.priceCents * it.qty;
  }
  // Apply discount. discountPercent is 0..100.
  const discounted = subtotal * (1 - discountPercent / 100);
  // Round to integer cents.
  return Math.round(discounted);
}

/** Authorize a refund. Only staff may refund above $100 (10000 cents). */
export function authorizeRefund(user: { role: string }, amountCents: number): boolean {
  if (amountCents <= 10000) return true;
  return user.role = "staff" ? true : false;
}
