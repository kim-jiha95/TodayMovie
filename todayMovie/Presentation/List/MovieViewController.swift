//
//  ViewController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/28.
//

import UIKit
import Combine

final class MovieViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    private let viewModel = MovieViewModel(networkClient: NetworkClient())
    private var cancellables: Set<AnyCancellable> = .init()
    
    private enum Section {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Movie>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<MovieViewController.Section, Movie>
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var dataSource: DataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reusableIdentifier)
//        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func makeDataSource() -> DataSource {
        let datasource = DataSource(tableView: tableView) { tableView, indexPath, movie -> UITableViewCell? in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: MovieCell.reusableIdentifier,
                    for: indexPath
                ) as? MovieCell
            else { return UITableViewCell() }
            let briefRank = indexPath.row
            cell.configure(with: movie, briefRank: briefRank)
            return cell
        }
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        datasource.apply(snapshot)
        return datasource
    }
    
    private func bindViewModel() {
//        viewModel.$movies
//            .print()
//            .removeDuplicates()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] movies in
//                guard let self else { return }
//                
//                var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>() // [] -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//                snapshot.appendSections([.main]) // [1, 2, 3, 4, 5]
//                snapshot.appendItems(movies)
//                self.dataSource.apply(snapshot, animatingDifferences: true) // [1, 2, 3, 4, 5]
//                
//                self.refreshControl.endRefreshing()
//            }
//            .store(in: &cancellables)
        
//        viewModel.movieUpdatehandler = { [weak self] movies in
//            guard let self else { return }
//            var snapshot: SnapShot = self.dataSource.snapshot() // 기존 snapshot [1, 2, 3, 4, 5]
//            print(movies, "movies")
//            snapshot.appendItems(movies) // 새로 더해질 무비의 배열 movies [6, 7, 8, 9, 10]
//            // 바뀐 snapshot = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
//            self.dataSource.apply(snapshot) // dataSource가 알아서 비교해서 더해줘요
//        }
        viewModel.movieUpdatehandler = { [weak self] movies in
            guard let self else { return }
            var snapshot: SnapShot = self.dataSource.snapshot() // 현재 snapshot [1, 2, 3, 4, 5]

            let newMoviesToAdd = movies.filter { movie in
                !snapshot.itemIdentifiers.contains { $0 == movie }
            }
            
            // snapshot과 중복을 피해서 새로 추가될 영화만 더함
            snapshot.appendItems(newMoviesToAdd)
            
            self.dataSource.apply(snapshot)
        }

        
        viewModel.errorHandler = { error in
            // 구현
        }
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "영화 검색"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    
    @objc private func refreshControlPulled() {
        viewModel.refreshControlPulled()
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// datasource -> diffable datasource
//extension MovieViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: MovieCell.reusableIdentifier,
//                for: indexPath
//            ) as? MovieCell
//        else { return UITableViewCell() }
//        let briefRank = indexPath.row
//        guard let movie = viewModel.movies[safe: indexPath.row]
//        else { return cell }
//        cell.configure(with: movie, briefRank: briefRank)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.movies.count
//    }
//    
//    func tableView(
//        _ tableView: UITableView,
//        willDisplay cell: UITableViewCell,
//        forRowAt indexPath: IndexPath
//    ) {
//        viewModel.willDisplay(rowAt: indexPath)
//    }
//}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedMovie = viewModel.movies[safe: indexPath.row] else { return }
        
        let movieDetailViewController = MovieDetailViewController(movie: selectedMovie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    func tableView(
            _ tableView: UITableView,
            willDisplay cell: UITableViewCell,
            forRowAt indexPath: IndexPath
        ) {
            // viewModel Bind
            viewModel.willDisplay(rowAt: indexPath)
        }
}

protocol NetworkFailureHandlingDelegate: AnyObject {
    func handleNetworkFailure(_ error: Error, retryHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void)
}

extension NetworkFailureHandlingDelegate where Self: UIViewController {
    func showNetworkFailureAlert(retryHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: "Error",
            message: "Err",
            preferredStyle: .alert
        )
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            retryHandler()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelHandler()
        }
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MovieViewController: NetworkFailureHandlingDelegate {
    func handleNetworkFailure(_ error: Error, retryHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        showNetworkFailureAlert(retryHandler: retryHandler, cancelHandler: cancelHandler)
    }
}

extension MovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.textDidChange(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarSearchButtonClicked()
        searchBar.resignFirstResponder()
    }
}
