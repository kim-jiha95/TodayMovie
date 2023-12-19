//
//  MovieDetailController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/30.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let movie: Movie
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
    
    /// UI Property
    /// Custom View (UIView)를 만들어서 ScrollView에 넣을 수도 있음
    /// 뷰컨트롤러와 뷰의 역할을 나누려면
    /// 커스텀 뷰가 있는것이 더 좋을 "수" 있다.
    /// 지금 MovieDetailViewController는 뷰를 보여주는 역할만 하고 있어서
    /// 굳이?
    /// 
    /// 뷰컨에서 다른 역할들을 많이 수행하고 있으면
    /// 커스텀뷰를 만드는게 더 나을 수도.
    /// 
    /// Cell -> TabeView, CollectionView에서만.
    
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
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

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

