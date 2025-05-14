//
//  ContentView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginShow: FirebaseViewModel
    
    var body: some View {
        Group {
            if loginShow.isLogged {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                loginShow.isLogged = true
            }
        }
    }
}

#Preview {
  
    ContentView()
}

