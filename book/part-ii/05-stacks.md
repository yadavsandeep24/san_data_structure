# Chapter 5 — Stacks

## Mobile motivation

Tap Back on Android. Swipe from the edge on iOS. Press the browser-style back affordance in a Flutter or React Navigation stack. Somewhere under that gesture sits a **stack**: the screen you leave is pushed; the screen you return to is popped. If that structure is wrong — duplicate routes, missing pops, or work done on every intermediate frame — users feel lost navigation and janky transitions.

Stacks also power undo/redo in editors, matching brackets in expression validators, DFS recursion (the call stack itself), and parsing deep JSON payloads without blowing the real stack. Understanding LIFO is how you debug “why did this screen reappear?” and “why did we OOM on a recursive tree walk?”

## What a stack is

A **stack** is Last-In, First-Out (LIFO). You only touch the top.

| Operation | Meaning | Target complexity |
|-----------|---------|-------------------|
| `push(x)` | Place `x` on top | O(1) amortized |
| `pop()` | Remove and return top | O(1) |
| `peek` / `top` | Read top without remove | O(1) |
| `isEmpty` | Empty check | O(1) |

You may implement a stack with a dynamic array (push/pop at the end) or a linked list (push/pop at the head). On modern mobile runtimes, **array-backed stacks win**: better locality, fewer allocations.

### Array as stack

- Kotlin: `ArrayDeque` (prefer) or `mutableListOf` with `add` / `removeLast`
- Swift: `Array` with `append` / `removeLast`
- Dart: `List` with `add` / `removeLast`
- TypeScript: `number[]` or generic `T[]` with `push` / `pop`

**Never** `removeAt(0)` / `removeFirst()` for stack behavior — that is O(n) and turns your “stack” into a slow queue.

## Complexity at a glance

| Backing | push | pop | peek | notes |
|---------|------|-----|------|-------|
| Dynamic array (end) | O(1) amortized | O(1) | O(1) | Preferred |
| Singly list (head) | O(1) | O(1) | O(1) | Extra node allocs |
| Array remove-from-front | O(n) | O(n) | O(1) | Anti-pattern |

## Platform bridges — navigation back-stacks

| Platform | Stack you touch |
|----------|-----------------|
| **Android** | `NavController` back stack; Activity task affinity; FragmentManager back stack. `popBackStack()` is the UI `pop`. |
| **iOS** | `UINavigationController` push/pop; SwiftUI `NavigationPath` is an explicit stack of values. |
| **Flutter** | `Navigator` / `Router` — `push` / `pop` / `popUntil`. `WillPopScope` / `PopScope` intercepts the pop. |
| **React Native** | React Navigation stack navigator; `navigation.push` / `goBack`; state is a route stack in the container. |

Mental model: **route identity lives on a stack**; presentation (animation, shared element) is layered on top. Bugs labeled “navigation” are often stack discipline bugs: push without matching pop, or pop while async work still expects that route to exist.

### Android: View-system back stack vs Navigation Compose

Android apps you join will usually have one of three back stacks — often two in the same app during a migration. All three are stacks of **entries**, not of screens' pixels.

| Stack operation | Views: `FragmentManager` | Views: Navigation component (XML nav graph + `NavHostFragment`) | Compose: Navigation Compose (`NavHost` + `NavController`) |
|-----------------|--------------------------|-----------------------------------------------------------------|-----------------------------------------------------------|
| push | `commit { replace(…); addToBackStack(name) }` | `findNavController().navigate(R.id.action_list_to_detail)` | `navController.navigate("detail/$id")` |
| pop | `popBackStack()` (async; `popBackStackImmediate()` is sync) | `findNavController().popBackStack()` / `navigateUp()` | `navController.popBackStack()` |
| pop-until | `popBackStack(name, POP_BACK_STACK_INCLUSIVE)` | `popBackStack(R.id.home, inclusive = false)` | `popBackStack("home", inclusive = false)` |
| replace top / dedupe | `replace` without `addToBackStack` | `navOptions { popUpTo(R.id.home) { inclusive = false }; launchSingleTop = true }` | `navigate(route) { popUpTo("home"); launchSingleTop = true }` |
| size / peek | `backStackEntryCount`, `getBackStackEntryAt(i)` | `currentBackStackEntry`, `previousBackStackEntry` | same, plus `currentBackStackEntryAsState()` in composition |
| What an entry owns | A transaction record (ops to reverse) | `NavBackStackEntry`: arguments, `ViewModelStore`, `SavedStateHandle`, lifecycle | Same `NavBackStackEntry` — Compose and Fragment navigation share the runtime |

Two consequences worth saying in an interview:

- **`FragmentManager` stores transactions, not screens.** Popping reverses the recorded ops; that is why forgetting `addToBackStack` means Back skips the screen entirely, and why `setReorderingAllowed(true)` matters when several ops collapse into one pop.
- **A `NavBackStackEntry` is a scope.** Its `ViewModel` lives exactly as long as the entry is on the stack — pop the entry and the ViewModel is cleared. Stack discipline therefore also controls memory and state lifetime in both toolkits.

Mixing during migration: a Fragment can host a `ComposeView` while the Navigation component (XML graph) keeps owning the stack; or a Compose `NavHost` can show a legacy screen through `AndroidView` (or `AndroidFragment` from `fragment-compose`). Pick **one** owner of the back stack per flow — two stacks (`FragmentManager` *and* `NavController`) both answering the same Back press is the classic "Back skipped a screen" bug.

### Predictive back: intercepting the pop

Back is dispatched through `OnBackPressedDispatcher`, which is itself a **stack of callbacks**: the most recently added *enabled* callback handles the event; if none is enabled, the system handles Back (finish the activity / go home). Both toolkits sit on the same dispatcher.

| Need | Views | Compose |
|------|-------|---------|
| Block Back while a form is dirty | `OnBackPressedCallback(enabled)` added via `requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner, callback)`; flip `isEnabled` | `BackHandler(enabled = hasUnsavedChanges) { … }` |
| Animate with the gesture (predictive back) | Override `handleOnBackStarted` / `handleOnBackProgressed(BackEventCompat)` / `handleOnBackCancelled` on the callback | `PredictiveBackHandler { progress: Flow<BackEventCompat> -> … }` — collect for progress; normal completion = committed, `CancellationException` = cancelled |
| Who wins when nested | Last added enabled callback (lifecycle-aware: removed when its owner is destroyed) | The most recently composed enabled `BackHandler` (usually the innermost) |

Keep callbacks **disabled** unless there is something to protect: the system can only play its predictive "peek at the previous screen" animation when no enabled app callback is going to take the event. Overriding `Activity.onBackPressed()` is deprecated and is not called once predictive back is in effect (opt-in via `android:enableOnBackInvokedCallback="true"` on Android 13–14; the default for apps targeting recent SDKs).

**Kotlin — Views**

```kotlin
class HostActivity : AppCompatActivity(R.layout.activity_host) {
    fun openDetail(id: String) {
        supportFragmentManager.commit {
            setReorderingAllowed(true)
            replace(R.id.container, DetailFragment.newInstance(id))
            addToBackStack("detail")                      // push
        }
    }
    fun back() = supportFragmentManager.popBackStack()    // pop (async)
    fun backToBeforeDetail() =                            // pop-until, inclusive
        supportFragmentManager.popBackStack("detail", FragmentManager.POP_BACK_STACK_INCLUSIVE)
    fun depth() = supportFragmentManager.backStackEntryCount // stack size
}

class EditorFragment : Fragment() {
    private var hasUnsavedChanges = false

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val callback = object : OnBackPressedCallback(false) {
            override fun handleOnBackProgressed(backEvent: BackEventCompat) {
                // predictive back: backEvent.progress goes 0f → 1f while the user drags
            }
            override fun handleOnBackPressed() = showDiscardDialog()
            override fun handleOnBackCancelled() { /* user let go: restore UI */ }
        }
        requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner, callback)
        callback.isEnabled = hasUnsavedChanges // enable only while there is something to protect
    }
    private fun showDiscardDialog() { /* … */ }
}
```

**Kotlin — Compose**

```kotlin
@Composable
fun AppNav(navController: NavHostController = rememberNavController()) {
    NavHost(navController, startDestination = "home") {
        composable("home") {
            HomeScreen(onOpen = { id -> navController.navigate("detail/$id") })   // push
        }
        composable("detail/{id}") { entry ->
            DetailScreen(
                id = entry.arguments?.getString("id").orEmpty(),
                onCheckout = {
                    navController.navigate("checkout") {
                        popUpTo("home")          // pop everything above home, then push
                        launchSingleTop = true   // no duplicate top entry on double-tap
                    }
                },
            )
        }
        composable("checkout") {
            CheckoutScreen(onDone = { navController.popBackStack("home", inclusive = false) })
        }
    }
}

@Composable
fun EditorScreen(hasUnsavedChanges: Boolean) {
    var showDialog by remember { mutableStateOf(false) }
    BackHandler(enabled = hasUnsavedChanges) { showDialog = true }
    if (showDialog) DiscardChangesDialog(onConfirm = { /* … */ }, onDismiss = { showDialog = false })
}

@Composable
fun SheetBack(onDismiss: () -> Unit) {
    var progress by remember { mutableFloatStateOf(0f) }
    PredictiveBackHandler { events: Flow<BackEventCompat> ->
        try {
            events.collect { progress = it.progress }   // animate with the gesture
            onDismiss()                                 // gesture committed
        } catch (e: CancellationException) {
            progress = 0f                               // gesture cancelled
            throw e
        }
    }
}
```

String routes are shown for brevity; Navigation 2.8+ also supports type-safe `@Serializable` route classes — the back stack semantics are the same. `HomeScreen`, `DetailScreen`, `CheckoutScreen`, `DetailFragment`, and `DiscardChangesDialog` are app-specific.

## Undo / redo

Model an editor with two stacks:

1. **Undo stack** — each successful edit pushes an inverse command (or a snapshot delta).
2. **Redo stack** — cleared on a new edit; undo pops undo and pushes onto redo; redo reverses that.

```text
type → push undo, clear redo
undo → pop undo, apply inverse, push redo
redo → pop redo, apply forward, push undo
```

Bound both stacks (e.g. 50–100 ops) so memory stays predictable on phones.

## Connection to the call stack

Every function call pushes a frame; every return pops one. Deep recursion (parsing nested comments, walking a skewed tree) can overflow the **native** call stack even when your heap is fine. On mobile:

- Prefer iterative algorithms with an **explicit** `ArrayDeque` / `Array` stack when depth can hit thousands.
- Tail recursion is not reliably optimized in Kotlin/Swift/Dart/JS the way it is in some functional VMs.
- Crash reports saying `StackOverflowError` / EXC_BAD_ACCESS near recursive helpers are your cue to convert to an explicit stack.

## Worked examples (four languages)

### Minimal stack wrapper

**Kotlin**

```kotlin
class Stack<T> {
    private val data = ArrayDeque<T>()
    fun push(x: T) = data.addLast(x)
    fun pop(): T = data.removeLast()
    fun peek(): T = data.last()
    fun isEmpty() = data.isEmpty()
}
```

**Swift**

```swift
struct Stack<Element> {
    private var data: [Element] = []
    mutating func push(_ x: Element) { data.append(x) }
    mutating func pop() -> Element? { data.popLast() }
    func peek() -> Element? { data.last }
    var isEmpty: Bool { data.isEmpty }
}
```

**Dart**

```dart
class Stack<E> {
  final _data = <E>[];
  void push(E x) => _data.add(x);
  E pop() => _data.removeLast();
  E get peek => _data.last;
  bool get isEmpty => _data.isEmpty;
}
```

**TypeScript**

```typescript
class Stack<T> {
  private data: T[] = [];
  push(x: T): void { this.data.push(x); }
  pop(): T | undefined { return this.data.pop(); }
  peek(): T | undefined { return this.data[this.data.length - 1]; }
  isEmpty(): boolean { return this.data.length === 0; }
}
```

### Valid parentheses (classic)

Push opening brackets; on close, pop and match. Empty stack at the end ⇒ valid.

**Kotlin**

```kotlin
fun isValid(s: String): Boolean {
    val st = ArrayDeque<Char>()
    val pair = mapOf(')' to '(', ']' to '[', '}' to '{')
    for (c in s) {
        if (c in "([{") st.addLast(c)
        else if (st.isEmpty() || st.removeLast() != pair[c]) return false
    }
    return st.isEmpty()
}
```

**Swift**

```swift
func isValid(_ s: String) -> Bool {
    var st: [Character] = []
    let pair: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if "([{".contains(c) { st.append(c) }
        else if st.isEmpty || st.removeLast() != pair[c] { return false }
    }
    return st.isEmpty
}
```

**Dart**

```dart
bool isValid(String s) {
  final st = <String>[];
  const pair = {')': '(', ']': '[', '}': '{'};
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if ('([{'.contains(c)) {
      st.add(c);
    } else if (st.isEmpty || st.removeLast() != pair[c]) {
      return false;
    }
  }
  return st.isEmpty;
}
```

**TypeScript**

```typescript
function isValid(s: string): boolean {
  const st: string[] = [];
  const pair: Record<string, string> = { ')': '(', ']': '[', '}': '{' };
  for (const c of s) {
    if ('([{'.includes(c)) st.push(c);
    else if (!st.length || st.pop() !== pair[c]) return false;
  }
  return st.length === 0;
}
```

### Min stack (O(1) getMin)

Keep a parallel stack of minima (or encode min into values). Each push records `min(x, currentMin)`.

**Kotlin**

```kotlin
class MinStack {
    private val vals = ArrayDeque<Int>()
    private val mins = ArrayDeque<Int>()

    fun push(x: Int) {
        vals.addLast(x)
        mins.addLast(if (mins.isEmpty()) x else minOf(x, mins.last()))
    }
    fun pop() { vals.removeLast(); mins.removeLast() }
    fun top() = vals.last()
    fun getMin() = mins.last()
}
```

**Swift**

```swift
final class MinStack {
    private var vals: [Int] = []
    private var mins: [Int] = []
    func push(_ x: Int) {
        vals.append(x)
        mins.append(mins.last.map { min(x, $0) } ?? x)
    }
    func pop() { vals.removeLast(); mins.removeLast() }
    func top() -> Int { vals.last! }
    func getMin() -> Int { mins.last! }
}
```

**Dart**

```dart
class MinStack {
  final _vals = <int>[];
  final _mins = <int>[];
  void push(int x) {
    _vals.add(x);
    _mins.add(_mins.isEmpty ? x : (x < _mins.last ? x : _mins.last));
  }
  void pop() { _vals.removeLast(); _mins.removeLast(); }
  int top() => _vals.last;
  int getMin() => _mins.last;
}
```

**TypeScript**

```typescript
class MinStack {
  private vals: number[] = [];
  private mins: number[] = [];
  push(x: number): void {
    this.vals.push(x);
    const m = this.mins.length ? Math.min(x, this.mins[this.mins.length - 1]) : x;
    this.mins.push(m);
  }
  pop(): void { this.vals.pop(); this.mins.pop(); }
  top(): number { return this.vals[this.vals.length - 1]; }
  getMin(): number { return this.mins[this.mins.length - 1]; }
}
```

## Common mistakes

1. **Using index 0 as the top** on an array — every push/pop shifts; use the end.
2. **Forgetting to clear redo** on a new edit — redo then reapplies stale history.
3. **Deep recursion instead of an explicit stack** — silent production crashes on large inputs.
4. **Holding Activity/Fragment/View references inside undo commands** — leaks; store IDs or value snapshots.
5. **Assuming `Stack` class on Android** — `java.util.Stack` is synchronized and legacy; prefer `ArrayDeque`.
6. **Two back-stack owners in one flow** — `FragmentManager` transactions *and* a `NavController` (or a Compose `NavHost` inside a Fragment that also uses `addToBackStack`) both consume Back; one pop skips a screen.
7. **Always-enabled back callbacks** — an enabled `OnBackPressedCallback` / `BackHandler` that just calls `popBackStack()` blocks the predictive-back animation; enable it only while there is state to protect.

## Self-Check

**5.1** Why must `push`/`pop`/`peek` be O(1) for a navigation back-stack under rapid gesture spam?

**5.2** How does `UINavigationController` relate to a stack? What is the “top”?

**5.3** Sketch undo/redo with two stacks after the sequence: type A, type B, undo, type C.

**5.4** When should you replace recursion with an explicit stack on mobile?

**5.5** Why is `ArrayDeque` preferred over `java.util.Stack` on Android?

**5.6** `OnBackPressedDispatcher` holds several callbacks. Which one handles Back, and how does that map to `BackHandler` in Compose?

*(Answers: Appendix D.)*

## Practice

1. **Valid parentheses** — [solutions/ch05](../../solutions/ch05/README.md#p1-valid-parentheses)
2. **Min stack** (`push`/`pop`/`top`/`getMin` all O(1)) — [solutions/ch05](../../solutions/ch05/README.md#p2-min-stack)
3. **Simplify absolute path** (Unix-style `/a/./b/../../c/`) — [solutions/ch05](../../solutions/ch05/README.md#p3-simplify-absolute-path)

Next: [Chapter 6 — Queues and Deques](06-queues-deques.md) — FIFO, sliding windows, and request queues.
