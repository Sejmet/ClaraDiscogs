//
//  SearchViewModel.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func searchArtists(query: String) {
        self.isLoading = true
        Task {
            do {
                let results = try await apiService.searchArtists(query: query)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.artists = results
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
