//
//  HomeRepoProtocol.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import RxSwift
import Foundation

protocol HomeRepoProtocol {
    func fetchMoviesData(page: Int) -> Observable<[MovieDTO]>
}
