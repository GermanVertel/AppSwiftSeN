//
//  ContentView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI

struct ContentView: View {
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
                
                FavoritosView(favoritos: $viewModel.favoritos)
                    .tabItem {
                        Label("Favoritos", systemImage: "heart.fill")
                    }
                    .tag(1)
                
               
            }
            .navigationBarHidden(true) // Oculta el título de la barra de navegación
        }
    }
}



#Preview {
    ContentView()
}

