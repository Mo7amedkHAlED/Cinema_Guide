//
//  HomeTableViewCell.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - OutLets
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!

    private var movieId: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupFavouriteButton()
    }
    
    private func setupUI() {
        movieName.font = UIFont.boldSystemFont(ofSize: 20)
        movieName.textColor = .black
        
        movieReleaseDate.font = UIFont.systemFont(ofSize: 16)
        movieReleaseDate.textColor = .gray
        
        movieRating.font = UIFont.systemFont(ofSize: 12)
        movieRating.textColor = .red
    }
    
    private func setupFavouriteButton() {
        favouriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        favouriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .selected)
        favouriteButton.tintColor = .red
        favouriteButton.backgroundColor = .clear
    }
    
    func setupCell(_ model: MovieEntity, isFavourite: Bool) {
        moviePoster.kf.setImage(with: URL(string: model.posterURL))
        movieName.text = model.title
        movieReleaseDate.text = model.releaseDate
        movieRating.text = model.rating
        favouriteButton.isSelected = isFavourite
    }
}
