//
//  ApiError.swift
//  VRefSolution ios app
//
//  Created by Yassine on 13/12/2022.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case noDate
    case noInternetConnection
    case decodingError
    case serviceUnavailable
    case custom(errorMessage: String)
}

extension ApiError: LocalizedError{
    
    var errorDescription: String?{
        switch self{
        case .invalidURL:
            return "URL is not correct"
        case .noDate:
            return "no data received error ....."
        case .noInternetConnection:
            return "No internet connection errorr ....."
        case .decodingError:
            return "decoding error ....."
        case .serviceUnavailable:
            return "service unavaible error ....."
        case .custom(errorMessage: let errorMessage):
            return "\(errorMessage)"
        }
    }
}
