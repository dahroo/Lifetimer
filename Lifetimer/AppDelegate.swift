import Cocoa
import SwiftUI

// Note: The @main attribute is removed from here. We will create a new entry point.
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var timerViewModel = TimerViewModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("✅ applicationDidFinishLaunching: App has launched.")

        // Create the status item in the menu bar.
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            print("✅ Status item button created successfully.")
            button.image = NSImage(systemSymbolName: "hourglass", accessibilityDescription: "Countdown Timer")
            button.action = #selector(togglePopover(_:))
        } else {
            print("❌ ERROR: Could not create the status item button.")
            // If you see this message, something is wrong with the menu bar itself.
        }

        // Create the popover that will be shown when the menu bar item is clicked.
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 350, height: 200)
        popover.behavior = .transient
        // The hosting controller will host our SwiftUI view.
        popover.contentViewController = NSHostingController(rootView: ContentView().environmentObject(timerViewModel))
        self.popover = popover
        print("✅ Popover created.")


        // Listen for changes in the timer's remaining time to update the menu bar.
        timerViewModel.onTimeUpdate = { [weak self] timeString in
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                self?.statusItem?.button?.title = timeString
                self?.statusItem?.button?.image = timeString.isEmpty ? NSImage(systemSymbolName: "hourglass", accessibilityDescription: "Countdown Timer") : nil
            }
        }
        
        // Listen for the timer reaching zero.
        timerViewModel.onTimerFinished = { [weak self] in
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                self?.statusItem?.button?.title = "---"
                self?.statusItem?.button?.image = nil
            }
        }
        print("✅ View model listeners configured.")
    }

    /// Toggles the visibility of the popover.
    @objc func togglePopover(_ sender: AnyObject?) {
        print("🎤 togglePopover: Menu bar item clicked.")
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(sender)
                print("    -> Closing popover.")
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                print("    -> Showing popover.")
            }
        } else {
             print("❌ ERROR: Status item button was nil when trying to toggle popover.")
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        print("🛑 applicationWillTerminate: App is closing.")
    }
}
