//
//  Coordinator.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled Gomaa on 30/11/2025.
//

import UIKit

@MainActor
protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
