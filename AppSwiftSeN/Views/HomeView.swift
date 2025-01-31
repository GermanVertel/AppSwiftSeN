//
//  HomeView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 2/01/25.
//



import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var viewModel: DalleViewModel
    @State private var texto: String = ""
    @State private var cargador: Bool = false
    @State private var mostrandoAlerta = false
    @Query private var imagenes: [ImageModel]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(imagenes) { imagen in
                            VStack {
                                Image(uiImage: imagen.image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(13)
                                    .padding()

                                HStack {
                                    Button(action: {
                                        guardarImagen(imagen: imagen.image)
                                    }) {
                                        HStack {
                                            Image(systemName: "square.and.arrow.down")
                                            Text("Descargar")
                                        }
                                        .foregroundColor(.blue)
                                    }
                                    .padding(.bottom, 10)

                                    Button(action: {
                                        marcarComoFavorito(imagen: imagen)
                                    }) {
                                        HStack {
                                            Image(systemName: imagen.isFavorite ? "heart.fill" : "heart")
                                            Text(imagen.isFavorite ? "Favorito" : "Marcar como Favorito")
                                        }
                                        .foregroundColor(.red)
                                    }
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }

                Divider()

                HStack {
                    TextField("Describe la imagen...", text: $texto)
                        .textFieldStyle(.roundedBorder)
                        .padding()

                    if cargador {
                        ProgressView().padding()
                    } else {
                        Button(action: generarImagen) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 25))
                                .padding()
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .padding(.bottom)
            }
            .navigationBarHidden(true)
            .alert(isPresented: $mostrandoAlerta) {
                Alert(
                    title: Text("Imagen guardada"),
                    message: Text("La imagen se ha guardado correctamente en tu galería."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // Función para generar una imagen
    func generarImagen() {
        guard !texto.isEmpty else { return }
        cargador = true
        Task {
            do {
                let nuevaImagen = try await viewModel.generarImagen(texto: texto)
                modelContext.insert(nuevaImagen)
                try? modelContext.save()
                cargador = false
            } catch {
                print("Error generando imagen: \(error)")
                cargador = false
            }
        }
    }

    // Función para guardar una imagen en la galería
    func guardarImagen(imagen: UIImage) {
        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
        mostrandoAlerta = true
    }

    // Función para marcar o desmarcar una imagen como favorita
    func marcarComoFavorito(imagen: ImageModel) {
        imagen.isFavorite.toggle()
        try? modelContext.save()
    }
}



