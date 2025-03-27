//
//  Transformer_HeartApp.swift
//  Transformer Heart
//
//  Created by nldxtd on 2025/1/10.
//

import SwiftUI

@main
struct Transformer_HeartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LaunchPage()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .preferredColorScheme(.light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .landscape
    }
}

