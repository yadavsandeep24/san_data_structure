// Platform bridges — navigation back-stacks
// Source: book/part-ii/05-stacks.md
package ch05.platform_bridges_navigation_back_stacks

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
