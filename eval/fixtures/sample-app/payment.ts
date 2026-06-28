// Sample fixture for Prism's grounding eval. Small, with clear invariants.
// The grounding verifier is scored on whether it confirms the TRUE claims and
// catches the FALSE/stale claims listed in ../grounding-key.md.

export type Cents = number; // INVARIANT: money is integer cents, never floats

export interface Charge {
  id: string;
  amountCents: Cents;
  idempotencyKey: string;
}

const seenKeys = new Set<string>();

/** Reject non-integer amounts — money must be integer cents. */
function assertCents(amount: number): void {
  if (!Number.isInteger(amount)) {
    throw new Error("amount must be integer cents");
  }
  if (amount <= 0) {
    throw new Error("amount must be positive");
  }
}

/** INVARIANT: auth is checked BEFORE any charge is created. */
export function charge(user: { authed: boolean }, c: Charge): Charge {
  if (!user.authed) {
    throw new Error("unauthorized"); // auth gate precedes all charge logic
  }
  assertCents(c.amountCents);
  // INVARIANT: a charge with a seen idempotency key is rejected (no double-charge).
  if (seenKeys.has(c.idempotencyKey)) {
    throw new Error("duplicate charge");
  }
  seenKeys.add(c.idempotencyKey);
  return c;
}
