//
//  APIEndpoint.swift
//  NewYorkTimes
//
//  Created by Belen on 03/12/2024.
//

import Foundation

enum APIEndpoint {
    case searchArtist(query: String)
    case artistDetails(id: Int)
    case artistAlbums(id: Int)
    
    var url: String {
        switch self {
        case .searchArtist(let query):
            guard let key = SecureStorage.shared.getFromKeychain(key: "APIKey"),
                  let secret = SecureStorage.shared.getFromKeychain(key: "APISecret") else {
                fatalError("API key and secret are not set in SecureStorage.")
            }
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(DiscogsAPIConfig.baseURL)database/search?q=\(encodedQuery)&type=artist&key=\(key)&secret=\(secret)"
        case .artistDetails(let id):
            return "\(DiscogsAPIConfig.baseURL)artists/\(id)"
        case .artistAlbums(let id):
            return "\(DiscogsAPIConfig.baseURL)artists/\(id)/releases"
        }
    }
}
