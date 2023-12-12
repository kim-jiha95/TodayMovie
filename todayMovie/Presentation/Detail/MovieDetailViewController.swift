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
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieDetailCell: MovieDetailCell = {
        let cell = MovieDetailCell()
        return cell
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
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            // safeArea 생각해서 잡아주시면 좋을 듯
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)

        ])
        stackView.addArrangedSubview(movieDetailCell)
        movieDetailCell.transferData(movie)
    }
}

