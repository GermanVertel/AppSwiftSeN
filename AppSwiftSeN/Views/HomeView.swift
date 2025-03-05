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
            VStack(spacing: 0) {
                // Barra superior personalizada
                HStack {
                    Text("Generador IA")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Área de imágenes generadas
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(imagenes) { imagen in
                            VStack(spacing: 8) {
                                Image(uiImage: imagen.image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(radius: 5)
                                    .padding(.horizontal)
                                
                                // Botones de acción
                                HStack(spacing: 20) {
                                    ActionButton(
                                        action: { marcarComoFavorito(imagen: imagen) },
                                        icon: imagen.isFavorite ? "heart.fill" : "heart",
                                        color: .red
                                    )
                                    
                                    ActionButton(
                                        action: { compartirImagen(imagen: imagen.image) },
                                        icon: "square.and.arrow.up",
                                        color: .green
                                    )
                                }
                                .padding(.bottom, 8)
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .gray.opacity(0.2), radius: 8)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color(.systemGray6))
                
                // Barra inferior de entrada
                VStack(spacing: 0) {
                    Divider()
                    HStack(spacing: 12) {
                        // Campo de texto mejorado
                        TextField("Describe tu imagen...", text: $texto)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Botón de generar
                        Button(action: generarImagen) {
                            if cargador {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "wand.and.stars.inverse")
                                    .font(.system(size: 20, weight: .semibold))
                            }
                        }
                        .frame(width: 44, height: 44)
                        .background(texto.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .disabled(texto.isEmpty || cargador)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                }
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

    // Función para generar una imagen
    func generarImagen() {
        guard !texto.isEmpty else { return }
        cargador = true
        Task {
            do {
                let nuevaImagen = try await viewModel.generarImagen(texto: texto)
                modelContext.insert(nuevaImagen)
                try? modelContext.save()
                await MainActor.run {
                    texto = "" // Limpiar el campo de texto
                    cargador = false
                }
            } catch {
                print("Error generando imagen: \(error)")
                await MainActor.run {
                    cargador = false
                }
            }
        }
    }

    // Función para marcar o desmarcar una imagen como favorita
    func marcarComoFavorito(imagen: ImageModel) {
        imagen.isFavorite.toggle()
        try? modelContext.save()
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
}

// Componente reutilizable para botones de acción
struct ActionButton: View {
    let action: () -> Void
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .foregroundColor(color)
                .clipShape(Circle())
        }
    }
}




