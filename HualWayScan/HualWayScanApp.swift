//
//  HualWayScanApp.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct HualWayScanApp: App {
    
    init() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
