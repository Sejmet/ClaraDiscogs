//
//  Artist.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import Foundation

struct SearchResults: Decodable {
    let results: [Artist]
}

struct Artist: Decodable, Identifiable {
    let id: Int
    let title: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumb
    }
}

