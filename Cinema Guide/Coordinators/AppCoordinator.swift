//
//  AppCoordinator.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled Gomaa on 30/11/2025.
//


import UIKit

class AppCoordinator: Coordinator,HomeCoordinator {
    var window: UIWindow
    
    var navigationController: UINavigationController
    
    init(scene: UIWindowScene, navigationController: UINavigationController) {
        self.navigationController = navigationController
        window = UIWindow(windowScene: scene)
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
    }
    
    func start() {
        let homeVC = HomeViewController()
        homeVC.coordinator = self 
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    func openDetails(for movie: MovieEntity) {
        let detailsCoordinator = DetailsCoordinatorImp(
            navigationController: navigationController,
            movie: movie
        )
        detailsCoordinator.start()
    }
}
