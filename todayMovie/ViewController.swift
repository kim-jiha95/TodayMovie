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
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var movies: [Movie] = []
    private let networkClient = NetworkClient()
    
    lazy var fetchDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fetch Data", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        // todo : self warning 고치면 Terminating app due to uncaught exception 'NSInvalidArgumentException
        button.addTarget(self, action: #selector(fetchDataButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(fetchDataButton)
        fetchDataButton.frame = CGRect(x: 100, y: 400, width: 200, height: 40)
    }

    @objc
    func fetchDataButtonPressed() {
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
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = "Rank: #, Title: \(movie.title), Popularity: \(movie.popularity)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }
}
