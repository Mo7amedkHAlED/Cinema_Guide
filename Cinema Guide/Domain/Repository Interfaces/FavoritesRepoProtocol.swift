//
//  FavoritesRepoProtocol.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled Gomaa on 30/11/2025.
//


import Foundation
import RxSwift

protocol FavoritesRepoProtocol {
    func getFavourites() -> Observable<Set<Int>>
    func toggleFavourite(id: Int) -> Observable<Bool>
    func isFavourite(id: Int) -> Observable<Bool>
}
