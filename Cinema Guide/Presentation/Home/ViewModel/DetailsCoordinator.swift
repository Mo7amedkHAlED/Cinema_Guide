//
//  DetailsCoordinator.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled Gomaa on 30/11/2025.
//

import UIKit


protocol DetailsCoordinator {
    func start()
}

final class DetailsCoordinatorImp: DetailsCoordinator, Coordinator {
    let navigationController: UINavigationController
    let movie: MovieEntity
    
    init(
        navigationController: UINavigationController,
        movie: MovieEntity) {
        self.navigationController = navigationController
        self.movie = movie
    }

    func start() {
        let viewModel = DetailsViewModel(movie: movie)
        let vc = DetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
