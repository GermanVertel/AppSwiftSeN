
//
//  Untitled.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 21/12/24.
//

import Foundation


struct ImageModel: Codable {
    
    struct ImageResponse: Codable {
        let url : URL
    }
    
    let created: Int
    let data: [ImageResponse]
    
}
