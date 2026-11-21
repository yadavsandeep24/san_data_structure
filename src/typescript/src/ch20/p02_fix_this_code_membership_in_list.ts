// P2: Fix this code — membership in list
// Source: solutions/ch20/README.md

// BAD — inside renderItem
function isInCartSlow(sku: string, cartSkus: string[]): boolean {
  return cartSkus.includes(sku); // O(m)
}

// GOOD — memoize / rebuild when cart changes
function buildCartSet(cartSkus: string[]): Set<string> {
  return new Set(cartSkus);
}

function isInCart(sku: string, cartSet: Set<string>): boolean {
  return cartSet.has(sku); // O(1)
}

export {};
