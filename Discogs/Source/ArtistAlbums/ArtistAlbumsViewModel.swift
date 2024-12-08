//
//  ArtistAlbumsViewModel.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import Foundation
import Combine

class ArtistAlbumsViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var filteredAlbums: [Album] = []
    @Published var errorMessage: String?
    @Published var isLoadingMore = false
    @Published var isLoading = false
    
    // Pagination
    private var currentPage = 1
    private var totalPages = 1
    private var isFetching = false
    
    // Filter Options
    @Published var selectedYear: Int?
    @Published var selectedGenre: String?
    @Published var selectedTitle: String?
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchAlbums(for artistId: Int) {
        guard !isFetching else { return }
        isFetching = true
        isLoading = true
        
        loadAlbums(for: artistId)
    }
    
    func loadMore(for artistId: Int) {
        guard !isFetching, currentPage <= totalPages else { return }
        isFetching = true
        isLoadingMore = true
        
        loadAlbums(for: artistId)
    }
    
    func applyFilters() {
        filteredAlbums = albums.filter { album in
            (selectedYear == nil || album.year == selectedYear) &&
            (selectedGenre == nil || album.type.contains(selectedGenre ?? "")) &&
            (selectedTitle == nil || album.title.contains(selectedTitle ?? ""))
        }
    }
    
    private func loadAlbums(for artistId: Int) {
        Task {
            do {
                let response = try await apiService.fetchAlbumsPaginated(
                    id: artistId,
                    page: currentPage,
                    perPage: 30,
                    sort: "year",
                    sortOrder: "desc"
                )
                DispatchQueue.main.async {
                    self.albums.append(contentsOf: response.releases)
                    self.filteredAlbums = self.albums
                    self.totalPages = response.pagination.pages
                    self.currentPage += 1
                    self.isFetching = false
                    self.isLoading = false
                    self.isLoadingMore = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isFetching = false
                    self.isLoading = false
                    self.isLoadingMore = false
                }
            }
        }
    }
}
