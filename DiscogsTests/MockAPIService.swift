//
//  MockAPIService.swift
//  DiscogsTests
//
//  Created by Belen on 03/12/2024.
//

import Foundation
@testable import Discogs

class MockAPIService: APIServiceProtocol {
    var mockArtists: [Artist] = []
    var mockArtistDetails: ArtistDetails?
    var mockAlbumsResponse: AlbumsResponse?
    var shouldThrowError = false
    
    func searchArtists(query: String) async throws -> [Artist] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return mockArtists
    }
    
    func fetchArtistDetails(id: Int) async throws -> ArtistDetails {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        guard let details = mockArtistDetails else {
            throw NSError(domain: "TestError", code: 2, userInfo: nil)
        }
        return details
    }
    
    func fetchAlbumsPaginated(id: Int, page: Int, perPage: Int, sort: String, sortOrder: String) async throws -> AlbumsResponse {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        guard let response = mockAlbumsResponse else {
            throw NSError(domain: "TestError", code: 2, userInfo: nil)
        }
        return response
    }
}
