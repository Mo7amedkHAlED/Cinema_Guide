//
//  NetworkError.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case noInternet
    case generalError
}

extension NetworkError {
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No Internet Connection, Please try again Later!"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data"
        case .generalError:
            return "Something went wrong, Please try again!"
        }
    }
}
