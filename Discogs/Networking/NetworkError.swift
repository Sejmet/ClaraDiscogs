//
//  NetworkError.swift
//  NewYorkTimes
//
//  Created by Belen on 03/12/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case unknownError(Error)
}
