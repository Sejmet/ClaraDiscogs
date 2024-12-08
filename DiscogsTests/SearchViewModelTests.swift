//
//  SearchViewModelTests.swift
//  DiscogsTests
//
//  Created by Belen on 03/12/2024.
//

import XCTest
@testable import Discogs

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = SearchViewModel(apiService: mockAPIService) // Inject mock
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testSearchArtistsSuccess() {
        // Arrange
        let mockArtists = [
            Artist(id: 1, title: "Artist 1", thumb: "https://example.com/image1.jpg"),
            Artist(id: 2, title: "Artist 2", thumb: "https://example.com/image2.jpg")
        ]
        mockAPIService.mockArtists = mockArtists

        // Act
        let expectation = XCTestExpectation(description: "Fetch artists")
        viewModel.searchArtists(query: "Test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertEqual(self.viewModel.artists.count, 2)
            XCTAssertEqual(self.viewModel.artists.first?.title, "Artist 1")
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchArtistsFailure() {
        // Arrange
        mockAPIService.shouldThrowError = true

        // Act
        let expectation = XCTestExpectation(description: "Handle error")
        viewModel.searchArtists(query: "Test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertEqual(self.viewModel.artists.count, 0)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
