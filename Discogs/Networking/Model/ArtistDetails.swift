//
//  ArtistDetails.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import Foundation

struct ArtistDetails: Decodable {
    let id: Int
    let name: String
    let profile: String
    let images: [Image]?
    let members: [BandMember]?
    let urls: [String]?

    struct Image: Decodable {
        let type: String
        let uri: String
        let uri150: String
        let width: Int
        let height: Int
    }

    struct BandMember: Decodable, Identifiable {
        let id: Int
        let name: String
        let active: Bool
    }
}
