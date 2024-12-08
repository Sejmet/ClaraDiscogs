//
//  ArtistDetailViewModelTests.swift
//  DiscogsTests
//
//  Created by Belen on 03/12/2024.
//

import XCTest
@testable import Discogs

class ArtistDetailViewModelTests: XCTestCase {
    var viewModel: ArtistDetailViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = ArtistDetailViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testFetchArtistDetailsSuccess() {
        // Arrange
        let mockDetails = ArtistDetails(
            id: 1,
            name: "Artist Name",
            profile: "Artist Profile",
            images: nil,
            members: nil,
            urls: nil
        )
        mockAPIService.mockArtistDetails = mockDetails
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch artist details")
        viewModel.fetchArtistDetails(id: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertEqual(self.viewModel.artistDetails?.name, "Artist Name")
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchArtistDetailsFailure() {
        // Arrange
        mockAPIService.shouldThrowError = true
        
        // Act
        let expectation = XCTestExpectation(description: "Handle fetch artist details error")
        viewModel.fetchArtistDetails(id: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Assert
            XCTAssertNil(self.viewModel.artistDetails)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

