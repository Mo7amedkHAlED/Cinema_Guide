//
//  HomeViewController.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled on 30/11/2025.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    // MARK: - OutLets
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel: HomeViewModel
    weak var coordinator: HomeCoordinator?
    private let bag = DisposeBag()
    
    // Footer for pagination loading
    private lazy var footerView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footer.center
        spinner.startAnimating()
        footer.addSubview(spinner)
        return footer
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Loading", attributes: attributes)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(pullToRefreshAction), for: .valueChanged)
        return refreshControl
    }()
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HomeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        configureNibFileTableView()
        tableViewSubscription()
        setNavigationController(true)
        subscribeToLoading()
        subscribeToPagination()
        subscribeToBranchSelection()
        setupPaginationTrigger()
        moviesTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController(true)
        moviesTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationController(false)
    }
    
    @objc private func pullToRefreshAction(_ sender: Any?) {
        viewModel.viewDidLoad()
        refreshControl.endRefreshing()
    }
    
    private func setNavigationController(_ isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
    
    private func configureNibFileTableView() {
        moviesTableView.register(UINib(nibName: String(describing: HomeTableViewCell.self), bundle: nil),forCellReuseIdentifier: String(describing: HomeTableViewCell.self))
    }
    
    private func subscribeToLoading() {
        viewModel.loadingBehavior.subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.hidesWhenStopped = true
                }
            }
        }).disposed(by: bag)
    }
    
    // MARK: - Pagination Loading Indicator
    private func subscribeToPagination() {
        viewModel.isPaginatingBehavior.subscribe(onNext: { [weak self] isPaginating in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isPaginating {
                    self.moviesTableView.tableFooterView = self.footerView
                } else {
                    self.moviesTableView.tableFooterView = nil
                }
            }
        }).disposed(by: bag)
    }
    
    // MARK: - Setup Pagination Trigger
    private func setupPaginationTrigger() {
        moviesTableView.rx.contentOffset
            .map { [weak self] offset in
                guard let self = self else { return false }
                let contentHeight = self.moviesTableView.contentSize.height
                let tableHeight = self.moviesTableView.frame.size.height
                let threshold: CGFloat = 100
                return offset.y + tableHeight >= contentHeight - threshold
            }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.loadMoreMovies()
            })
            .disposed(by: bag)
    }
    
    private func subscribeToBranchSelection() {
        moviesTableView.rx.modelSelected(MovieEntity.self)
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                self.coordinator?.openDetails(for: movie)
            }).disposed(by: bag)
    }
    
    private func tableViewSubscription() {
        viewModel.moviesBehavior
            .bind(to: moviesTableView.rx.items(
                cellIdentifier: String(describing: HomeTableViewCell.self),
                cellType: HomeTableViewCell.self)) { [weak self] _, element, cell in
                    guard let self = self else { return }
                    cell.selectionStyle = .none
                    
                    self.viewModel.isFavourite(id: element.id)
                        .subscribe(onNext: { isFavourite in
                            cell.setupCell(element, isFavourite: isFavourite)
                        })
                        .disposed(by: self.bag)
                    
                    cell.favouriteButton.rx.tap
                        .flatMap { [weak self] _ -> Observable<Bool> in
                            guard let self = self else { return .empty() }
                            return self.viewModel.toggleFavourite(id: element.id)
                        }
                        .subscribe(onNext: { isFavourite in
                            cell.favouriteButton.isSelected = isFavourite
                        })
                        .disposed(by: self.bag)
                }.disposed(by: bag)
    }
}
