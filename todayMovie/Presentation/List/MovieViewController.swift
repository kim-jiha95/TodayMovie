//
//  ViewController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/28.
//

import UIKit

/// 테이블 뷰에 랭킹을 표시하고,
///     테이블 뷰를 코드로 먼저 그리고
///     테이블 뷰 셀도 따로 UI를 그리고
///     페이지 연결도 코드로 하고
///     셀이 눌렸을 때 이벤트도 연결하고
///     API를 찔러오는 시점은 버튼 터치가 아닌 view 가 로드된 시점
/// 테이블 뷰 셀에 그 영화를 누르면, 영화의 디테일한 정보가 표시된다. -> 그 영화의 사진을 포함한 다른 정보들을 그냥 대충 그려주시면 될 것 같아요
///     API에서 사진을 어떻게 주는지 분석.
///     API에서 사진을 받아서 표시해주시면 될 것 같아요.

final class MovieViewController: UIViewController {
    
    private var movies: [Movie] = []
    private let networkClient = NetworkClient()
    
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
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // safeArea 생각해서 잡아주시면 좋을 듯
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchMovieData() {
        let parameters: Parameters = [
            "api_key": NetworkConstant.tmdbAPIKey,
            "language": "ko-KR",
            "append_to_response": "videos"
        ]
        
        networkClient.request(
            endpoint: Endpoint.Movie.topRated(parameters),
            for: MovieData.self
        ) { [weak self] result in
            self?.handle(result: result)
        }
    }
    
    private func handle(result: Result<MovieData, Error>) {
        DispatchQueue.main.async {
            switch result {
            case let .success(movieData):
                self.movies = movieData.results
                self.tableView.reloadData()
                
                // 추가, 삭제, 삽입 (CRUD) 에서도 reloadData()를 하면
                // 화면이 깜빡일거에요 자기가 있던 위치에 안있을 수 있을거에요
                // perform batch updates
                // compositional layout
                
            case .failure(let error):
                /// 에러가 발생하면
                /// 1. 목데이터를 보여준다던가
                /// 2. alert을 띄운다던가
                /// 3. 에러 뷰를 띄운다던가 (다시시도 버튼)
                print(error)
            }
        }
    }
}

extension MovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieCell.cellId, 
                for: indexPath
            ) as? MovieCell 
        else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movies, "movie")
        return movies.count
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
