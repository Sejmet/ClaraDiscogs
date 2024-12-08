//
//  ArtistAlbumsViewModelTests.swift
//  DiscogsTests
//
//  Created by Belen on 03/12/2024.
//

import XCTest
@testable import Discogs

class ArtistAlbumsViewModelTests: XCTestCase {
    var viewModel: ArtistAlbumsViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = ArtistAlbumsViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchAlbumsSortedByYear() {
        // Arrange
        let mockAlbums = [
            Album(id: 1, title: "Newest Album", year: 2023, type: "master", artist: "Artist", thumb: "", resourceURL: ""),
            Album(id: 2, title: "Older Album", year: 2022, type: "master", artist: "Artist", thumb: "", resourceURL: "")
        ]
        mockAPIService.mockAlbumsResponse = AlbumsResponse(
            pagination: Pagination(perPage: 2, items: 2, page: 1, pages: 1),
            releases: mockAlbums
        )
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch albums sorted by year")
        viewModel.fetchAlbums(for: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertEqual(self.viewModel.albums.first?.year, 2023)
            XCTAssertEqual(self.viewModel.albums.last?.year, 2022)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchAlbumsFailure() {
        // Arrange
        mockAPIService.shouldThrowError = true
        
        // Act
        let expectation = XCTestExpectation(description: "Handle fetch albums error")
        viewModel.fetchAlbums(for: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertEqual(self.viewModel.albums.count, 0)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPaginationWith30ItemsPerPage() {
        // Arrange
        let page1Albums = (1...30).map {
            Album(id: $0, title: "Album \($0)", year: 2023, type: "master", artist: "Artist", thumb: "", resourceURL: "")
        }
        let page2Albums = (31...60).map {
            Album(id: $0, title: "Album \($0)", year: 2022, type: "master", artist: "Artist", thumb: "", resourceURL: "")
        }
        
        mockAPIService.mockAlbumsResponse = AlbumsResponse(
            pagination: Pagination(perPage: 30, items: 60, page: 1, pages: 2),
            releases: page1Albums
        )
        
        let expectation = XCTestExpectation(description: "Fetch albums with 30 items per page")
        
        // Act
        viewModel.fetchAlbums(for: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mockAPIService.mockAlbumsResponse = AlbumsResponse(
                pagination: Pagination(perPage: 30, items: 60, page: 2, pages: 2),
                releases: page2Albums
            )
            self.viewModel.fetchAlbums(for: 1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Assert
                XCTAssertEqual(self.viewModel.albums.count, 60)
                XCTAssertEqual(self.viewModel.albums.first?.title, "Album 1")
                XCTAssertEqual(self.viewModel.albums.last?.title, "Album 60")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
