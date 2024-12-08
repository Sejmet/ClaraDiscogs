//
//  ArtistDetailViewModel.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import Foundation

class ArtistDetailViewModel: ObservableObject {
    @Published var artistDetails: ArtistDetails?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchArtistDetails(id: Int) {
        self.isLoading = true
        Task {
            do {
                let details = try await apiService.fetchArtistDetails(id: id)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.artistDetails = details
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
