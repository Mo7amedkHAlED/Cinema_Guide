//
//  HomeViewModel.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import RxSwift
import RxRelay
import Foundation

protocol HomeViewModelProtocol {
    var moviesBehavior: BehaviorRelay<[MovieEntity]> { get }
    var loadingBehavior: BehaviorRelay<Bool> { get }
    var isPaginatingBehavior: BehaviorRelay<Bool> { get }
    func viewDidLoad()
    func loadMoreMovies()
    func toggleFavourite(id: Int) -> Observable<Bool>
    func isFavourite(id: Int) -> Observable<Bool>
}

class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Variables
    var moviesBehavior: BehaviorRelay<[MovieEntity]> = .init(value: [])
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var isPaginatingBehavior = BehaviorRelay<Bool>(value: false)
    let bag = DisposeBag()
    
    private let homeUseCase: HomeUseCase
    private let favoritesRepo: FavoritesRepoProtocol
    private var currentPage = 1
    private var canLoadMore = true
    
    // MARK: - Init
    init(homeUseCase: HomeUseCase = HomeUseCaseImple(),
         favoritesRepo: FavoritesRepoProtocol = FavoritesRepoImple()) {
        self.homeUseCase = homeUseCase
        self.favoritesRepo = favoritesRepo
    }
    
    // MARK: - viewDidLoad
    func viewDidLoad() {
        resetPagination()
        fetchMoviesInformation()
    }
    
    // MARK: - Load More
    func loadMoreMovies() {
        guard canLoadMore, !isPaginatingBehavior.value else { return }
        currentPage += 1
        fetchMoviesInformation(isPaginating: true)
    }
    
    private func resetPagination() {
        currentPage = 1
        canLoadMore = true
        moviesBehavior.accept([])
    }
    
    func toggleFavourite(id: Int) -> Observable<Bool> {
        return favoritesRepo.toggleFavourite(id: id)
    }
    
    func isFavourite(id: Int) -> Observable<Bool> {
        return favoritesRepo.isFavourite(id: id)
    }
    
    private func fetchMoviesInformation(isPaginating: Bool = false) {
        setLoadingState(isPaginating, isLoading: true)
        homeUseCase
            .fetchMoviesData(page: currentPage)
            .observe(on: MainScheduler.instance)
            .materialize()
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let movies):
                    self.handleSuccess(movies, isPaginating: isPaginating)
                case .error:
                    self.handleError(isPaginating: isPaginating)
                case .completed:
                    break
                }
            }).disposed(by: bag)
    }

    private func setLoadingState(_ isPaginating: Bool, isLoading: Bool) {
        switch isPaginating {
        case true:
            isPaginatingBehavior.accept(isLoading)
        default:
            loadingBehavior.accept(isLoading)
        }
    }

    private func handleSuccess(_ movies: [MovieEntity], isPaginating: Bool) {
        canLoadMore = !movies.isEmpty
        let updatedMovies = isPaginating ? moviesBehavior.value + movies : movies
        moviesBehavior.accept(updatedMovies)
        setLoadingState(isPaginating, isLoading: false)
    }

    private func handleError(isPaginating: Bool) {
        canLoadMore = false
        setLoadingState(isPaginating, isLoading: false)
    }
}
