//
//  DetailsViewModel.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import Foundation
import RxSwift
import RxRelay

protocol DetailsViewModelProtocol {
    var movie: MovieEntity { get }
    func toggleFavourite() -> Observable<Bool>
    func isFavourite() -> Observable<Bool>
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    // MARK: - Variables
    let movie: MovieEntity
    private let bag = DisposeBag()
    private let favoritesRepo: FavoritesRepoProtocol

    // MARK: - Init
    init(movie: MovieEntity, favoritesRepo: FavoritesRepoProtocol = FavoritesRepoImple()) {
        self.movie = movie
        self.favoritesRepo = favoritesRepo
    }
    
    func toggleFavourite() -> Observable<Bool> {
        return favoritesRepo.toggleFavourite(id: movie.id)
    }
    
    func isFavourite() -> Observable<Bool> {
        return favoritesRepo.isFavourite(id: movie.id)
    }
}
