//
//  FavoritosView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI
import SwiftData

struct FavoritosView: View {
    @Query(filter: #Predicate<ImageModel> { $0.isFavorite }) private var favoritos: [ImageModel]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                if favoritos.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No hay favoritos.")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        
                        Text("Las imágenes que marques como favoritas aparecerán aquí")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(favoritos) { imagen in
                                VStack(spacing: 8) {
                                    Image(uiImage: imagen.image)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    Button(action: { marcarComoNoFavorito(imagen: imagen) }) {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Color.red.opacity(0.1))
                                            .clipShape(Circle())
                                    }
                                }
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                                .padding(.horizontal, 4)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favoritos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func marcarComoNoFavorito(imagen: ImageModel) {
        withAnimation {
            imagen.isFavorite = false
            try? modelContext.save()
        }
    }
}
