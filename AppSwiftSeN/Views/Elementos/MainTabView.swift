//
//  MainTabView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 12/05/25.
//

import SwiftUI

// MainTabView.swift
struct MainTabView: View {
    @StateObject private var viewModel = DalleViewModel()
    @State private var selectedTab = 0
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: viewModel)
                .environmentObject(firebaseViewModel)
                    .tabItem {
                        Label("Generador", systemImage: "photo")
                    }
                    .tag(0)
                
                FavoritosView()
                .environmentObject(firebaseViewModel)
                    .tabItem {
                        Label("Favorito", systemImage: "heart.fill")
                    }
                    .tag(1)
        }
    }
}

#Preview {
    MainTabView()
}
