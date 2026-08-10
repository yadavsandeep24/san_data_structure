function uniquePreserveOrder(ids) {
  const seen = new Set();
  const out = [];
  for (const id of ids) {
    if (!seen.has(id)) {
      seen.add(id);
      out.push(id);
    }
  }
  return out;
}

function kLargest(nums, k) {
  const heap = [];
  const siftUp = (i) => {
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (heap[i] >= heap[p]) break;
      [heap[i], heap[p]] = [heap[p], heap[i]];
      i = p;
    }
  };
  const siftDown = (i) => {
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < heap.length && heap[l] < heap[best]) best = l;
      if (r < heap.length && heap[r] < heap[best]) best = r;
      if (best === i) break;
      [heap[i], heap[best]] = [heap[best], heap[i]];
      i = best;
    }
  };
  for (const n of nums) {
    heap.push(n);
    siftUp(heap.length - 1);
    if (heap.length > k) {
      const last = heap.pop();
      if (heap.length) {
        heap[0] = last;
        siftDown(0);
      }
    }
  }
  return [...heap].sort((a, b) => b - a);
}

const u = uniquePreserveOrder(["a", "b", "a", "c"]);
if (u.join(",") !== "a,b,c") throw new Error("unique " + u);
const k = kLargest([3, 1, 5, 2, 4], 3);
if (k.join(",") !== "5,4,3") throw new Error("kLargest " + k);
console.log("ts");
