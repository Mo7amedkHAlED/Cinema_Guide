//
//  SceneDelegate.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        coordinator = AppCoordinator(scene: windowScene, navigationController: navigationController)
        coordinator?.start()
    }
}
