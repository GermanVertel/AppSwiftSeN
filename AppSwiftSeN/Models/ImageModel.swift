
//
//  Untitled.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import SwiftData
import Foundation
import UIKit

@Model
final class ImageModel {
    var id: UUID
    var imageData: Data
    var isFavorite: Bool
    var createdAt: Date

    init(imageData: Data, isFavorite: Bool = false) {
        self.id = UUID()
        self.imageData = imageData
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }

    var image: UIImage {
        UIImage(data: imageData) ?? UIImage()
    }
}
