//
//  ContentView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftUI

// Estructura para hacer las imágenes identificables
struct IdentifiableImage: Identifiable {
    let id = UUID() // Generar un identificador único
    let image: UIImage
    var isFavorite: Bool = false // Estado para marcar si la imagen es favorita
}

struct ContentView: View {
    @State private var texto: String = ""
    @State private var imagenes: [IdentifiableImage] = [] // Array de IdentifiableImage
    @State private var favoritos: [IdentifiableImage] = [] // Array para imágenes favoritas
    @State private var cargador: Bool = false
    @State private var mostrandoAlerta = false // Estado para mostrar una alerta cuando la imagen se guarde correctamente
    
    @StateObject var dalle = DalleViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // Vista de las imágenes generadas
                ScrollView {
                    LazyVStack {
                        ForEach(imagenes) { imagen in
                            VStack {
                                Image(uiImage: imagen.image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(13)
                                    .padding()

                                // Botón de descarga debajo de cada imagen
                                Button(action: {
                                    guardarImagen(imagen: imagen.image)
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.down")
                                        Text("Descargarr")
                                    }
                                    .foregroundColor(.blue)
                                }
                                .padding(.bottom, 10)
                                
                                // Botón para marcar como favorito
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
                
                Divider()
                
                // Campo de texto para la descripción de la imagen
                HStack {
                    TextField("Describe la imagen...", text: $texto)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        
                    // Botón para generar la imagen
                    if cargador {
                        ProgressView()
                            .padding()
                    } else {
                        Button(action: {
                            generarImagen()
                        }) {
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
            .navigationTitle("Generador de Imágenes")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $mostrandoAlerta) {
                Alert(title: Text("Imagen guardada"), message: Text("La imagen se ha guardado correctamente en tu galería."), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritosView(favoritos: $favoritos)) {
                        HStack {
                            Image(systemName: "heart.fill")
                            Text("Favoritos")
                        }
                    }
                }
            }
        }
    }
    
    // Función para generar la imagen
    func generarImagen() {
        guard !texto.isEmpty else { return }
        
        cargador = true
        Task {
            do {
                let response = try await dalle.generarImagen(texto: texto)
                if let url = response.data.map(\.url).first {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let imagen = UIImage(data: data) {
                        let nuevaImagen = IdentifiableImage(image: imagen) // Crear una IdentifiableImage
                        imagenes.insert(nuevaImagen, at: 0) // Insertar la imagen en la parte superior
                    }
                }
                cargador = false
            } catch {
                print("Error generando imagen: \(error)")
                cargador = false
            }
        }
    }
    
    // Función para guardar la imagen en la galería del dispositivo
    func guardarImagen(imagen: UIImage) {
        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
        mostrandoAlerta = true // Mostrar alerta cuando la imagen se guarde
    }
    
    // Función para marcar una imagen como favorita
    func marcarComoFavorito(imagen: IdentifiableImage) {
        if let index = imagenes.firstIndex(where: { $0.id == imagen.id }) {
            imagenes[index].isFavorite.toggle() // Cambiar el estado de favorito
            if imagenes[index].isFavorite {
                favoritos.append(imagenes[index]) // Agregar a favoritos si está marcado
            } else {
                favoritos.removeAll { $0.id == imagen.id } // Quitar de favoritos si se desmarca
            }
        }
    }
}



#Preview {
    ContentView()
}

