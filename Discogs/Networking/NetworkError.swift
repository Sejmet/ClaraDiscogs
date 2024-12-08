import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case unknownError(Error)
}
