// P3: Stable key generator
// Source: solutions/ch19/README.md

type FeedEntry =
  | { type: "post"; id: string }
  | { type: "ad"; id: string }
  | { type: "header"; sectionId: string };

function stableKey(entry: FeedEntry): string {
  switch (entry.type) {
    case "post":
      if (!entry.id) throw new Error("blank id");
      return `post:${entry.id}`;
    case "ad":
      if (!entry.id) throw new Error("blank id");
      return `ad:${entry.id}`;
    case "header":
      if (!entry.sectionId) throw new Error("blank id");
      return `header:${entry.sectionId}`;
  }
}

// FlatList: keyExtractor={(item) => stableKey(item)}

export {};
