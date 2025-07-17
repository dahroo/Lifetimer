//
//  MenuBarCountdownApp.swift
//  Lifetimer
//
//  Created by Andrew Zhou on 7/17/25.
//


import SwiftUI

@main
struct MenuBarCountdownApp: App {
    // This line is the key. It creates the AppDelegate instance and connects it
    // to the SwiftUI application lifecycle.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // We return a Settings scene. This is a trick to create a menu bar app
        // that has no main window. The app will launch, but no window will appear.
        Settings {
            // The content of the settings window is empty because we don't need one.
            EmptyView()
        }
    }
}
