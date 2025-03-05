//
//  ContentView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = DalleViewModel()
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
  
    ContentView()
}

