//
//  AppSwiftSeNApp.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI
import SwiftData

@main
struct AppSwiftSeNApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ImageModel.self) // Configura el contenedor de SwiftData
        }
    }
}
