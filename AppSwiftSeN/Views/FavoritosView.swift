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
    @Environment(\.modelContext) private var modelContext // Contexto de SwiftData

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if favoritos.isEmpty {
                        Text("No hay imágenes favoritas")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(favoritos) { imagen in
                            VStack {
                                Image(uiImage: imagen.image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(13)
                                    .padding()

                                Text("ID: \(imagen.id)")
                                Text("Fecha: \(imagen.createdAt)")
                                
                                Button(action: {
                                    marcarComoNoFavorito(imagen: imagen)
                                }) {
                                    HStack {
                                        Image(systemName: "heart.fill")
                                        Text("Quitar de Favoritos")
                                    }
                                    .foregroundColor(.red)
                                }
                                .padding(.bottom, 10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favoritos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Función para quitar una imagen de favoritos
    func marcarComoNoFavorito(imagen: ImageModel) {
        imagen.isFavorite = false
        try? modelContext.save() // Guardar cambios en SwiftData
    }
}
