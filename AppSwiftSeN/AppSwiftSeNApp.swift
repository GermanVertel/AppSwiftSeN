//
//  AppSwiftSeNApp.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct AppSwiftSeNApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .modelContainer(for: ImageModel.self) // Configura el contenedor de SwiftData
            }
            
        }
    }
}
