//
//  HomeView.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 2/01/25.
//



import SwiftUI


// Estructura para hacer las imágenes identificables
struct IdentifiableImage: Identifiable {
    let id = UUID() // Generar un identificador único
    let image: UIImage
    var isFavorite: Bool = false // Estado para marcar si la imagen es favorita
}

struct HomeView: View {
    @State private var texto: String = ""
    @State private var imagenes: [IdentifiableImage] = []
    @State private var cargador: Bool = false
    @State private var mostrandoAlerta = false
    @ObservedObject var viewModel: DalleViewModel // Usa el modelo compartido
    
    var body: some View {
        NavigationStack {
            VStack {
                // Lista de imágenes generadas
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
                
                // Campo de texto para descripción
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
            .navigationBarHidden(true) // Oculta la barra de navegación y el título
            .alert(isPresented: $mostrandoAlerta) {
                Alert(
                    title: Text("Imagen guardada"),
                    message: Text("La imagen se ha guardado correctamente en tu galería."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func generarImagen() {
        guard !texto.isEmpty else { return }
        cargador = true
        Task {
            do {
                let response = try await viewModel.generarImagen(texto: texto)
                if let url = response.data.map(\.url).first {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let imagen = UIImage(data: data) {
                        let nuevaImagen = IdentifiableImage(image: imagen)
                        imagenes.insert(nuevaImagen, at: 0)
                    }
                }
                cargador = false
            } catch {
                print("Error generando imagen: \(error)")
                cargador = false
            }
        }
    }
    
    func guardarImagen(imagen: UIImage) {
        UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
        mostrandoAlerta = true
    }
    
    func marcarComoFavorito(imagen: IdentifiableImage) {
        if let index = imagenes.firstIndex(where: { $0.id == imagen.id }) {
            imagenes[index].isFavorite.toggle()
            if imagenes[index].isFavorite {
                viewModel.favoritos.append(imagenes[index])
            } else {
                viewModel.favoritos.removeAll { $0.id == imagen.id }
            }
        }
    }
}




