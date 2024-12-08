//
//  Album.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import Foundation

struct Album: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let year: Int?
    let type: String
    let artist: String
    let thumb: String
    let resourceURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case type
        case artist
        case thumb
        case resourceURL = "resource_url"
    }
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AlbumsResponse: Decodable {
    let pagination: Pagination
    let releases: [Album]
}

struct Pagination: Decodable {
    let perPage: Int
    let items: Int
    let page: Int
    let pages: Int

    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case items
        case page
        case pages
    }
}
