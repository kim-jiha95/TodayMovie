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

class MovieViewModel {
    /// 결과값 State
    @Published var movies: [Movie] = []
    private let networkClient: NetworkRequestable
    private var currentPage = 1
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
    weak var delegate: NetworkFailureHandlingDelegate?
    
    
    var updateHandler: (() -> Void)?
    
    func viewDidLoad() {
        fetchMovieData()
    }
    
    func fetchMovieData() {
        let parameters = createAPIParameters()
        loadMovies(with: parameters)
    }
    
    func loadMovies(with parameters: Parameters) {
        print(currentPage, "currentpage")
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
            delegate?.handleNetworkFailure(error, retryHandler: {
                self.fetchMovieData()
            }, cancelHandler: {
                // user canceled
            })
        }
    }
    
    func fetchNextPage() {
        print("fetchNextPage?")
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
    
    func getMovie(at index: Int) -> Movie? {
        return movies[safe: index]
    }
}
