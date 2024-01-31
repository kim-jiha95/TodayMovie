//
//  MovieViewModel.swift
//  todayMovie
//
//  Created by Jihaha kim on 2024/01/11.
//

import Foundation

// Interface Segregation Principle
// Dependency Inversion Principle

protocol NetworkRequestable {
    func request<T: Decodable>(
        endpoint: URLRequestConfigurable,
        for type: T.Type,
        completionHandler: @escaping (Result<T, Error>) -> Void
    )
}

final class MovieViewModel {
    
    // MARK: Constant
    
    private enum Constant {
        static let startPage: Int = 1
    }
    
    // MARK: Bindable/Observable Property
    
    var movies: [Movie] = []
    var movieUpdatehandler: (([Movie]) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    // MARK: Private Property
    
    private let networkClient: NetworkRequestable
    private var currentPage = Constant.startPage
    private var searchText: String = ""
    
    // MARK: Initializer
    
    init(
        movies: [Movie] = [],
        networkClient: NetworkRequestable,
        currentPage: Int = Constant.startPage
    ) {
        self.movies = movies
        self.networkClient = networkClient
        self.currentPage = currentPage
    }
    weak var delegate: NetworkFailureHandlingDelegate?
    
    // MARK: View에서 보내주는 Actions
    
    func viewDidLoad() {
        fetchMovieData()
    }
    
    func textDidChange(_ searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked() {
        guard !searchText.isEmpty else {
            // Handle empty search text
            return
        }
        
        clear()
        networkClient.request(
            endpoint: Endpoint.Movie.search(query: searchText, page: currentPage),
            for: MovieData.self
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleNetworkResult(result)
            }
        }
    }
    
    func willDisplay(rowAt indexPath: IndexPath) {
        let currentRow: Int = indexPath.row
        let currentAmount: Int = movies.count
        guard currentRow.hasReachedThreshold(outOf: currentAmount) else { return }
        fetchMovieData()
    }
    
    func refreshControlPulled() {
        clear()
        fetchMovieData()
    }
    
    // MARK: Private Methods
    
    private func fetchMovieData() {
        networkClient.request(
            endpoint: Endpoint.Movie.topRated(page: currentPage),
            for: MovieData.self
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleNetworkResult(result)
            }
        }
    }
    
    private func handleNetworkResult(_ result: Result<MovieData, Error>) {
        switch result {
            //        case let .success(movieData):
            //            let newMovies = movieData.results
            //            if currentPage == Constant.startPage {
            //                movies = newMovies
            //                movieUpdatehandler?(newMovies)
            //            } else {
            //                movies.append(contentsOf: newMovies)
            //                movieUpdatehandler?(newMovies)
            //            }
            //            currentPage += 1
            //
            //        case let .failure(error):
            //            delegate?.handleNetworkFailure(error, retryHandler: {
            //                self.fetchMovieData()
            //            }, cancelHandler: {
            //                // user click cancel
            //            })
            //        }
        case .success(let movieData):
            // Update movies with new data
            self.movies = movieData.results
            // Notify delegate or update UI
            movieUpdatehandler?(self.movies)
        case .failure(let error):
            // Handle error, show alert or retry
            errorHandler?(error)
        }
        
    }
    
    private func clear() {
        currentPage = Constant.startPage
    }
}

fileprivate extension Int {
    func hasReachedThreshold(outOf count: Int, threshold: Int = 5) -> Bool {
        if self >= count - threshold {
            return true
        } else {
            return false
        }
    }
}
