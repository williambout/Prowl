//
//  ProwlApp.swift
//  Prowl
//
//  Created by William on 1/13/24.
//

import SwiftUI

@main
struct ProwlApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
