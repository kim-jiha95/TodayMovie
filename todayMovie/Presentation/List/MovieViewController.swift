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
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    /// 어떤 행동을 할지 x
    /// 함수 이름은 어떤 행동이 일어났는지
    /// 
    @objc private func refreshControlPulled() {
        currentPage = 1
        movies.removeAll()
        fetchMovieData()
    }

    /// 문제점 1. 하나의 함수가 너무 여러개의 일을 하고 있어요.
    /// 1. 파라미러틀 정의하고
    /// 2. tableView의 상태와 page의 상태 관리
    /// 3. networkClient.request
    /// 4. result에 대한 성공 핸들링
    /// 5. result에 대한 실패 핸들링
    /// 
    /// 숙제2: 
    /// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting
    /// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety
    /// https://medium.com/@almalehdev/you-dont-always-need-weak-self-a778bec505ef
    /// 
    /// 숙제3: 
    /// 처음 data를 받아오는 함수와
    /// pagination으로 받아오는 함수를 분리하면 좋을 것 같아요.
    /// 
    /// 숙제4: 
    /// 에러처리 -> 알럿을 띄워서 
    /// 재시도 버튼과 취소 버튼
    /// 재시도 시 다시 (전에 시도한) API를 찔러오는 것
    /// 취소시 취소
    /// 
    func fetchMovieData() {
        let parameters: Parameters = [
            "api_key": NetworkConstant.tmdbAPIKey,
            "language": "ko-KR",
            "page": "\(currentPage)",
            "append_to_response": "videos"
        ]
        
        /// 문제점 3. tableView.reloadData
        /// 깜빡임 문제가 발생해요.
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
                // 문제점 2. 실패에 대한 처리
                DispatchQueue.main.async {
                    let alertController = UIAlertController(
                        title: "Error",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    
                    let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                        self.fetchMovieData()
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                        self.refreshControl.endRefreshing()
                    }
                    
                    alertController.addAction(retryAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
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

    /// 숙제 5: 
    /// API를 찌를 때 print로 찌르는 시점과 current page를 확인해보고
    /// willDisplay함수가 어느 시점에 몇번 불리는지 확인해보고
    /// 
    /// movies.count - 1 -> 마지막에 닿아야 불리는 코드
    /// 내리면 쭉쭉 내려가려면 어떻게 다듬으면 좋을지
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
