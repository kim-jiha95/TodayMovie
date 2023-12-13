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
///     
///     
/// 12월 11일
/// 7-2. 순위 자리에  썸네일 이미지를 1:1로 넣어주시고,
/// 처음 받아올 때 인디케이터 로딩
/// 이후에는 캐싱되어서 로딩이 안걸리도록
/// 
/// 7-3. 맨 위에서 땅겼을 경우 리프레쉬 되도록
///
final class MovieViewController: UIViewController {
    
    private var movies: [Movie] = []
    private let networkClient = NetworkClient()
    private var currentPage = 1
    
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
                self.movies.append(contentsOf: newMovies)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.currentPage += 1
                
            case let .failure(error):
                /// 에러대응
                /// alert을 띄운다던가
                ///  에러 뷰를 띄운다던가 (다시시도 버튼)
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
        // 1 = magic number, 다른 사람이 봤을 때 무엇을 의미하는지 모르는 숫자 or 문자 -> 지양
        // 이럴 때는 주석을 쓰는게 좋다.
        // 주석: 히스토리가 복잡하거나, 로직이 복잡하거나, 의도를 파악하기 힘들 거 같을 때
        let briefRank = indexPath.row 
        let movie = movies[indexPath.row] // safe casting
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
