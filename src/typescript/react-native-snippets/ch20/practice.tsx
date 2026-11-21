// Practice
// Source: book/part-v/20-decision-guide.md
// React Native snippet: needs a React Native project (not type-checked here).

// FlatList renderItem — runs for every visible row during scroll
const renderRow = (sku: string, cartSkus: string[]) => (
  <Switch value={cartSkus.includes(sku)} /> // ???
);
