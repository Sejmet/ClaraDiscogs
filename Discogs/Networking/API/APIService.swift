import Foundation

protocol APIServiceProtocol {
    func searchArtists(query: String) async throws -> [Artist]
    func fetchArtistDetails(id: Int) async throws -> ArtistDetails
    func fetchAlbumsPaginated(id: Int, page: Int, perPage: Int, sort: String, sortOrder: String) async throws -> AlbumsResponse
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    private init() {}

    func searchArtists(query: String) async throws -> [Artist] {
        let endpoint = APIEndpoint.searchArtist(query: query).url
        return try await NetworkLayer.shared.request(
            endpoint: endpoint,
            method: .GET,
            responseType: SearchResults.self
        ).results
    }
    
    func fetchArtistDetails(id: Int) async throws -> ArtistDetails {
        let endpoint = APIEndpoint.artistDetails(id: id).url
        return try await NetworkLayer.shared.request(
            endpoint: endpoint,
            method: .GET,
            responseType: ArtistDetails.self
        )
    }
    
    func fetchAlbumsPaginated(
        id: Int,
        page: Int,
        perPage: Int = 30,
        sort: String = "year",
        sortOrder: String = "desc"
    ) async throws -> AlbumsResponse {
        let endpoint = "\(APIEndpoint.artistAlbums(id: id).url)?page=\(page)&per_page=\(perPage)&sort=\(sort)&sort_order=\(sortOrder)"
        
        return try await NetworkLayer.shared.request(
            endpoint: endpoint,
            method: .GET,
            responseType: AlbumsResponse.self
        )
    }
}
