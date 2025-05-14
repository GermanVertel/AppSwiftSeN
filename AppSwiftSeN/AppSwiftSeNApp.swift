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
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        let login = FirebaseViewModel()
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(login)
                    .modelContainer(for: ImageModel.self) // Configura el contenedor de SwiftData
            }
            
        }
    }
}
