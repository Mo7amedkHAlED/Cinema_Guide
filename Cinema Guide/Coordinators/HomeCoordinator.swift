//
//  HomeCoordinator.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled Gomaa on 30/11/2025.
//

import UIKit

protocol HomeCoordinator: AnyObject {
    func openDetails(for movie: MovieEntity)
    func start()
}
