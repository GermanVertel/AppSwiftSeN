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
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: viewModel)
                    .tabItem {
                        Label("Generador", systemImage: "photo")
                    }
                    .tag(0)
                
                FavoritosView()
                    .tabItem {
                        Label("Favorito", systemImage: "heart.fill")
                    }
                    .tag(1)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainTabView()
}
