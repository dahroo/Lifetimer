import SwiftUI

@main
struct MenuBarCountdownApp: App {
    // 1. The ViewModel is now created and owned by the App itself as a @StateObject.
    //    This ensures it lives for the entire lifecycle of the app.
    @StateObject private var timerViewModel = TimerViewModel()

    // 2. A @State variable to hold the text that will be displayed in the menu bar.
    @State private var menuBarText: String = "⏳" // Default is an hourglass emoji

    var body: some Scene {
        // 3. This is the new, pure SwiftUI way to create a menu bar item.
        //    The string passed here is what's shown in the menu bar. It automatically
        //    updates whenever the @State variable `menuBarText` changes.
        MenuBarExtra(menuBarText) {
            // The content of the popover goes here.
            // We pass the view model down to the ContentView.
            ContentView()
                .environmentObject(timerViewModel)
                // 4. The .task modifier is moved here, onto the root view
                //    of the MenuBarExtra's content. This correctly attaches the
                //    task to the view's lifecycle.
                .task {
                    // We tell the view model what to do when the time updates.
                    timerViewModel.onTimeUpdate = { timeString in
                        // If the time string is valid, display it.
                        // Otherwise, reset to the default hourglass.
                        menuBarText = timeString.isEmpty ? "⏳" : timeString
                    }

                    // We tell the view model what to do when the timer finishes.
                    timerViewModel.onTimerFinished = {
                        menuBarText = "---"
                    }
                    
                    // This is a new method to initialize the state from persistence.
                    timerViewModel.initializeTimerState()
                }
        }
        // This tells the MenuBarExtra to behave like a standard menu item,
        // which gives us the popover behavior we want.
        .menuBarExtraStyle(.window)
    }
}
