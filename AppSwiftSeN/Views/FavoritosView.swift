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
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    @State private var imagenSeleccionada: ImageModel? = nil
    @State private var mostrandoAlerta = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                // Contenido principal
                VStack(spacing: 0) {
                    if favoritos.isEmpty {
                        Spacer()
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
                        Spacer()
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
                                            .onTapGesture {
                                                imagenSeleccionada = imagen
                                            }
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
            }
            .navigationTitle("Favoritos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    MenuHamburguesaView()
                }
            }
            .sheet(item: $imagenSeleccionada) { imagen in
                FullScreenFavoritosImageView(
                    imagen: imagen,
                    onClose: { imagenSeleccionada = nil },
                    onToggleFavorito: {
                        marcarComoNoFavorito(imagen: imagen)
                        imagenSeleccionada = nil
                    },
                    onCompartir: {
                        imagenSeleccionada = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            compartirImagen(imagen: imagen.image)
                        }
                    },
                    onDescargar: {
                        imagenSeleccionada = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            guardarImagenEnGaleria(imagen: imagen.image)
                        }
                    },
                    onEliminar: {
                        eliminarImagen(imagen: imagen)
                        imagenSeleccionada = nil
                    }
                )
            }
            .alert(isPresented: $mostrandoAlerta) {
                Alert(
                    title: Text("¡Listo!"),
                    message: Text("La imagen se ha guardado en tu galería"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func marcarComoNoFavorito(imagen: ImageModel) {
        withAnimation {
            imagen.isFavorite = false
            try? modelContext.save()
        }
    }
    
    func compartirImagen(imagen: UIImage) {
        let activityViewController = UIActivityViewController(
            activityItems: [imagen],
            applicationActivities: nil
        )
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(activityViewController, animated: true)
        }
    }
    
    func guardarImagenEnGaleria(imagen: UIImage) {
        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
        mostrandoAlerta = true
    }
    
    func eliminarImagen(imagen: ImageModel) {
        modelContext.delete(imagen)
        try? modelContext.save()
    }
}

struct FullScreenFavoritosImageView: View {
    let imagen: ImageModel
    let onClose: () -> Void
    let onToggleFavorito: () -> Void
    let onCompartir: () -> Void
    let onDescargar: () -> Void
    let onEliminar: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                Image(uiImage: imagen.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                Spacer()
                HStack(spacing: 20) {
                    ActionButton(
                        action: onToggleFavorito,
                        icon: "heart.slash",
                        color: .red
                    )
                    ActionButton(
                        action: onCompartir,
                        icon: "square.and.arrow.up",
                        color: .green
                    )
                    ActionButton(
                        action: onDescargar,
                        icon: "arrow.down.to.line.alt",
                        color: .blue
                    )
                    ActionButton(
                        action: onEliminar,
                        icon: "trash",
                        color: .gray
                    )
                }
                .padding(.bottom, 32)
            }
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
