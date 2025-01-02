//
//  FavoritosView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI



struct FavoritosView: View {
    @Binding var favoritos: [IdentifiableImage] // Array de imágenes favoritas

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(favoritos) { imagen in
                    Image(uiImage: imagen.image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(13)
                        .padding()
                }
            }
        }
        .navigationTitle("Favoritos")
        .navigationBarTitleDisplayMode(.inline)
    }
}
