//
//  ViewController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/28.
//

import UIKit

final class MovieViewController: UIViewController {
    
    private var movies: [Movie] = []
    private let networkClient = NetworkClient()
    private var currentPage = 1
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMovieData()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reusableIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        currentPage = 1
        movies.removeAll()
        fetchMovieData()
    }
    
    func fetchMovieData() {
        let parameters: Parameters = [
            "api_key": NetworkConstant.tmdbAPIKey,
            "language": "ko-KR",
            "page": "\(currentPage)",
            "append_to_response": "videos"
        ]
        
        let newMovies: [Movie] = []
        movies.append(contentsOf: newMovies)
        tableView.reloadData()
        currentPage += 1
        
        networkClient.request(
            endpoint: Endpoint.Movie.topRated(parameters),
            for: MovieData.self
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(movieData):
                let newMovies = movieData.results
                
                if self.currentPage == 1 {
                    self.movies = newMovies
                } else {
                    self.movies.append(contentsOf: newMovies)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                
                self.currentPage += 1
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func handle(result: Result<MovieData, Error>) {
        DispatchQueue.main.async {
            switch result {
            case let .success(movieData):
                self.movies = movieData.results
                self.tableView.reloadData()
                
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                print(error)
            }
        }
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

extension MovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieCell.reusableIdentifier,
                for: indexPath
            ) as? MovieCell
        else { return UITableViewCell() }
        let briefRank = indexPath.row
        guard let movie = movies[safe: indexPath.row]
        else { return cell } //mock data cell or error alert cell
        cell.configure(with: movie, briefRank: briefRank)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            fetchMovieData()
        }
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = movies[indexPath.row]
        let movieDetailViewController = MovieDetailViewController(movie: selectedMovie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
