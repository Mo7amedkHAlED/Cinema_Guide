//
//  HomeUseCase.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    func fetchMoviesData(page: Int) -> Observable<[MovieEntity]>
}

class HomeUseCaseImple: HomeUseCase {
    
    private let repo: HomeRepoProtocol
    
    init(repo: HomeRepoProtocol = HomeRepoImple()) {
        self.repo = repo
    }
    
    func fetchMoviesData(page: Int) -> Observable<[MovieEntity]> {
        repo.fetchMoviesData(page: page)
            .map { $0.map { $0.toEntity() } }
    }
}
