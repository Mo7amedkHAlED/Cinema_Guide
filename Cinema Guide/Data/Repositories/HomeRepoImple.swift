//
//  HomeRepoImple.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import Foundation
import RxSwift

class HomeRepoImple: HomeRepoProtocol {
    
    private let networkService: APIService
    
    init(networkService: APIService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchMoviesData(page: Int) -> Observable<[MovieDTO]> {
        
        let baseUrl = URL(string: "\(Constants.baseUrl)/discover/movie")!
        
        let queryItems = [
            URLQueryItem(name: "api_key", value: Constants.apiKey),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        return networkService.fetch(urlRequest: request)
            .flatMap { data -> Observable<[MovieDTO]> in
                do {
                    let decoded = try JSONDecoder().decode(MoviesResponse.self, from: data)
                    return .just(decoded.results)
                } catch {
                    return .error(NetworkError.generalError)
                }
            }
    }
}
