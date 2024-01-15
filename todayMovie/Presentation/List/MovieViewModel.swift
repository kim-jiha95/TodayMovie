//
//  MovieViewModel.swift
//  todayMovie
//
//  Created by Jihaha kim on 2024/01/11.
//

import Foundation
/// 뷰모델은 UI와 관련이 없어야 합니다.
import UIKit

// Interface Segregation Principle
// Dependency Inversion Principle

protocol NetworkRequestable {
    func request<T: Decodable>(
        endpoint: URLRequestConfigurable,
        for type: T.Type,
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) 
}

class MovieViewModel {
    /// 결과값 State
    @Published var movies: [Movie] = []
    private let networkClient: NetworkRequestable
    private var currentPage = 1
    
    /// 이친구를 지워주세요
    private let refreshControl = UIRefreshControl()
    
    // 의존성 주입
    init(
        movies: [Movie] = [],
        networkClient: NetworkRequestable,
        currentPage: Int = 1,
        updateHandler: (() -> Void)? = nil
    ) {
        self.movies = movies
        self.networkClient = networkClient
        self.currentPage = currentPage
        self.updateHandler = updateHandler
    }
    
    var updateHandler: (() -> Void)?
    
    func viewDidLoad() {
        fetchMovieData()
    }
    
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
    
    // 이친구들은 뷰모델이 아니라 뷰에 있어야해요.
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
//            viewModel.retryButtonTapped()
            self.fetchMovieData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            viewModel.cancelButtonTapped()
            self.refreshControl.endRefreshing()
        }
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
//            self.present(alertController, animated: true, completion: nil)
    }
    
    /// 외부에서 몰라도 되는 함수는 private
    func fetchNextPage() {
        currentPage += 1
        fetchMovieData()
    }
    
    /// Action -> Mutation
    func refreshControlPulled() {
        currentPage = 1
        movies.removeAll()
        fetchMovieData()
    }
    
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    /// 10000개 index 9999
    func getMovie(at index: Int) -> Movie? {
        return movies[safe: index]
    }
}
