//
//  DalleViewModel.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 2/01/25.
//


import Foundation

class DalleViewModel: ObservableObject {
    @Published var favoritos: [ImageModel] = []
    let session: String

    init() {
        self.session = UUID().uuidString
    }

    func generarImagen(texto: String) async throws -> ImageModel {
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            throw ImageError.badURL
        }

        let parametros: [String: Any] = [
            "prompt": texto,
            "n": 1,
            "size": "1024x1024",
            "user": self.session
        ]

        let data: Data = try JSONSerialization.data(withJSONObject: parametros)
        
        let apikey = Secrets.openAIKey
        
      
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data

        let (response, _) = try await URLSession.shared.data(for: request)
        
        // Decodificar la respuesta de la API
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: response)
        
        // Convertir la respuesta de la API en una instancia de ImageModel
        guard let imageURL = apiResponse.data.first?.url else {
            throw ImageError.imageCreationFailed
        }
        
        // Descargar la imagen desde la URL
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        
        // Crear una instancia de ImageModel
        let imageModel = ImageModel(imageData: imageData)
        return imageModel
    }
}

enum ImageError: Error {
    case badURL
    case imageCreationFailed
}
