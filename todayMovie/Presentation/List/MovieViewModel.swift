//
//  MovieViewModel.swift
//  todayMovie
//
//  Created by Jihaha kim on 2024/01/11.
//

import Foundation
import UIKit

class MovieViewModel {
    private var movies: [Movie] = []
    private let networkClient = NetworkClient()
    private var currentPage = 1
    private let refreshControl = UIRefreshControl()
    
    var updateHandler: (() -> Void)?
    
    func fetchMovieData() {
        let parameters = createAPIParameters()
        loadMovies(with: parameters)
    }
    
    func loadMovies(with parameters: Parameters) {
        networkClient.request(
            endpoint: Endpoint.Movie.topRated(parameters),
            for: MovieData.self
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleNetworkResult(result)
            }
        }
    }
    
    func createAPIParameters() -> Parameters {
        return [
            "api_key": NetworkConstant.tmdbAPIKey,
            "language": "ko-KR",
            "page": "\(currentPage)",
            "append_to_response": "videos"
        ]
    }
    
    func updateMovies(with newMovies: [Movie]) {
        if currentPage == 1 {
            movies = newMovies
        } else {
            movies.append(contentsOf: newMovies)
        }
        updateHandler?()
    }
    
    func handleNetworkResult(_ result: Result<MovieData, Error>) {
        switch result {
        case let .success(movieData):
            let newMovies = movieData.results
            updateMovies(with: newMovies)
            
        case let .failure(error):
            handleNetworkFailure(error)
        }
    }
    // 객체를 만들거나, protocol화 해서 사용하면 좋음
    func handleNetworkFailure(_ error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        /// escaping인데, self를 weak로 안잡으면 메모리릭
        /// escaping인데, self를 weak로 잡으면 괜찮구
        ///
        /// non-escaping인데, self를 weak로 안잡으면 delay-deallocation
        /// non-escaping인데, self를 weak로 잡으면 괜찮구
        ///
        let retryAction = UIAlertAction(title: "Retry", style: .default) {_ in
            self.fetchMovieData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.refreshControl.endRefreshing()
        }
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
//            self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchNextPage() {
        currentPage += 1
        fetchMovieData()
    }
    
    func resetData() {
        currentPage = 1
        movies.removeAll()
        fetchMovieData()
    }
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    func getMovie(at index: Int) -> Movie? {
        guard movies.indices.contains(index) else {
            return nil
        }
        return movies[index]
    }
}
