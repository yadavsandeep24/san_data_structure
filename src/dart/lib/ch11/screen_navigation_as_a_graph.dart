// Screen navigation as a graph
// Source: book/part-iii/11-graphs-intro.md

final nav = <String, List<String>>{
  'Home': ['Product', 'Login', 'Cart'],
  'Product': ['Cart', 'Home'],
  'Cart': ['Checkout', 'Home'],
  'Checkout': ['Home'],
  'Login': ['Home'],
};
