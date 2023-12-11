//
//  MovieDetailController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let movie: Movie
    
    /// table view, scrollview + stackview, collection view
    /// 
    /// 1. scrollview + stackview
    /// 컨텐츠의 내용이 반복적이지 않고, 양이 적고, 정적일 때
    /// 
    /// 2. table view
    /// 컨텐츠가 반복적이거나, 양이 많거나, 동적으로 변할 때
    /// 가로의 넓이가 화면 사이즈에 고정
    /// 
    /// 3. collection view
    /// 넓이를 dynamic하게 설정
    /// 
    /// 숙제2. scrollview+stackview로 변경
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        print(movie)
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
        
        tableView.register(MovieDetailCell.self, forCellReuseIdentifier: MovieDetailCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movie, "movie")
//        return movie.genre_ids.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailCell.cellId, for: indexPath) as! MovieDetailCell
        cell.transferData(movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
