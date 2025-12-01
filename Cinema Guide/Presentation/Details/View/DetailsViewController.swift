//
//  DetailsViewController.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailsViewController: UIViewController {
    
    // MARK: - OutLets
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieOriginalLanguage: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Properties
    private let viewModel: DetailsViewModel
    private let bag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailsViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateMovieData()
        setupFavouriteButton()
        bindFavouriteButton()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = viewModel.movie.title
        
        // Poster
        moviePoster.contentMode = .scaleAspectFill
        moviePoster.clipsToBounds = true
        moviePoster.layer.cornerRadius = 12
        moviePoster.layer.borderWidth = 0.5
        moviePoster.layer.borderColor = UIColor.lightGray.cgColor
        moviePoster.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // Movie Name
        movieName.font = .boldSystemFont(ofSize: 20)
        movieName.textColor = .black
        movieName.numberOfLines = 2
        movieName.adjustsFontSizeToFitWidth = true
        movieName.minimumScaleFactor = 0.8
        
        // Rating
        movieRating.font = .systemFont(ofSize: 16, weight: .medium)
        movieRating.textColor = .red
        
        // Release Date
        movieReleaseDate.font = .systemFont(ofSize: 14)
        movieReleaseDate.textColor = .systemGray
        
        // Overview
        movieOverview.font = .systemFont(ofSize: 14)
        movieOverview.textColor = .darkGray
        movieOverview.numberOfLines = 4
        movieOverview.lineBreakMode = .byTruncatingTail
        
        // Original Language
        movieOriginalLanguage.font = .systemFont(ofSize: 14, weight: .semibold)
        movieOriginalLanguage.textColor = .gray
    }
    
    private func populateMovieData() {
        movieName.text = "Name: \(viewModel.movie.title)"
        movieRating.text = "Rating: \(viewModel.movie.rating)"
        movieOverview.text = viewModel.movie.overview
        movieOriginalLanguage.text = "Original Language: \(viewModel.movie.originalLanguage)"
        movieReleaseDate.text = viewModel.movie.releaseDate
        moviePoster.kf.setImage(with: URL(string: viewModel.movie.posterURL))
    }
    
    private func setupFavouriteButton() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        
        favouriteButton.setImage(
            UIImage(systemName: "suit.heart", withConfiguration: symbolConfig),
            for: .normal
        )
        favouriteButton.setImage(
            UIImage(systemName: "suit.heart.fill", withConfiguration: symbolConfig),
            for: .selected
        )
        
        favouriteButton.tintColor = .red
        favouriteButton.backgroundColor = .clear
        favouriteButton.contentMode = .center  // ⭐ مهم
    }
    
    // MARK: - Bindings
    private func bindFavouriteButton() {
        // Bind initial favourite state
        viewModel.isFavourite()
            .bind(to: favouriteButton.rx.isSelected)
            .disposed(by: bag)
        
        // Handle tap to toggle
        favouriteButton.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .empty() }
                return self.viewModel.toggleFavourite()
            }
            .bind(to: favouriteButton.rx.isSelected)
            .disposed(by: bag)
    }
}
