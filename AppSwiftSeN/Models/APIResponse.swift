//
//  APIResponse.swift
//  AppSwiftSeN
//
//  Created by German David Vertel Narvaez on 29/01/25.
//

import Foundation

struct APIResponse: Decodable {
    struct ImageResponse: Decodable {
        let url: URL
    }

    let created: Int
    let data: [ImageResponse]
}
