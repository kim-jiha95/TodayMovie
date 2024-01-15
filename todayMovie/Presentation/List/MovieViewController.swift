//
//  ViewController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/28.
//

import UIKit
import Combine

/// 숙제: MVC -> MVVM으로 바꿔볼거에요
/// 
/// 꼭 해야하는 숙제: MVVM 관련 자료들 미리 학습하고, MVVM을 왜 써야하는가?
/// 시간이 남으면: MVVM으로 바꿔보기
/// 
/// MVVM을 왜 써야하는가?
/// 바꿔보고 남은거 해오고
/// 
/// 비동기 처리는 일단 closure
/// closure -> Combine or async/await로 바꿀거에요 -> 개념학습 2주 +, 코드를 변환 2주 +
///
/// 꼭은 아니지만 확실하게 좋은 곳 붙으려면 해야하는
/// 1. 아키텍쳐
/// MVC -> MVVM
/// MVVM -> Clean Architecture
/// Clean Architecture -> 지하님의 선택에 맞는 아키텍쳐를 만들기 (아마 하기 힘들거구)
/// 
/// 1.5 최적화
/// reloadData
/// 
/// 2. 모듈화
/// TodayMovie -> Movie
///         -> UI
///         -> Account 
///         -> Nework
/// 
/// command + B -> xcode가 어떻게 빌드를 해서 어떤 순서로 바이너리 파일들을 만드는지
/// 
/// 신입한테 기대를 할 수도, 안 할수도
/// 만약에 물어봤는데, 대답을 잘한다 -> 엄청난 +
/// 
/// 5년차 되도 모르는 사람들이 많음
/// 
/// 유행이고, 사람들이 많이 요즘 관심을 가지는
/// 
/// 3. 테스트코드 작성
///  
/// 과제 국룰
/// 구조: MVVM -> CleanArchitecture
/// 비동기: async / combine / rxswift
/// 테스트코드: optional
/// swift 기초지식들을 완벽하게 알기
/// 
/// 블로그
/// 저는 강추
/// 첫글 closure로 기대해도 될까요?
/// 
/// velog -> google에 잘 노출되더라구요?, 돈은 안돼요. 제일 쉽게 쓸 수 있어서, 퀄리티가 좀 낮은 느낌?
/// tstory -> 노출은 잘 모르겠는데, 유명해지면 간식비정도?
/// medium -> 예쁜데, 돈을 써야 보는? 제일 퀄리티가 높은
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 1월 15일 기준
/// 숙제
/// 1. 뷰에서 바인딩 시 insert 구현
/// 2. 뷰모델 로직 정리
/// 
/// 뷰 관련 이슈들
/// 1. 검색어를 입력받아서 영화 검색하기
/// 2. 기본적으로 내장되어야할 파라미터 분리

/// 4. 에러처리
/// 
/// 뷰모델 관련 이슈들

/// 2. 뷰모델 구현 고도화
///
/// 기타 기능 
/// 1. 이미지 캐싱 고도화
///     1.1) 로드하는 아이와, 캐시를 들고있는 아이를 분리
///     1.2) 캐시를 actor로 변환
///     1.3) memory cache, disk cache 구현
/// 2. 테스트 코드 작성 
final class MovieViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    private let viewModel = MovieViewModel(networkClient: NetworkClient())
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        viewModel.viewDidLoad()
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
    
    private func bindViewModel() {
        viewModel.$movies
            .sink { movie in
                print(movie)
            }
            .store(in: &cancellables)
        
        /// [movie]을 받아서 
        /// reloadData 사용 없이
        /// tableview insert -> 어려울 수 있음
        /// 
        /// diffable datasource -> 새로 공부하는 것도 어려울 수 있어요
        viewModel.updateHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    /// 어떤 행동을 할지 x
    /// 함수 이름은 어떤 행동이 일어났는지
    /// Action
    @objc private func refreshControlPulled() {
        viewModel.refreshControlPulled()
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
        guard let movie = viewModel.getMovie(at: indexPath.row)
                
        else { return cell } //mock data cell or error alert cell
        cell.configure(with: movie, briefRank: briefRank)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold: Int = 5
        let shouldFetchData: Bool = indexPath.row >= (viewModel.numberOfMovies() - threshold)
        
        guard shouldFetchData else { return }
        viewModel.fetchMovieData()
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedMovie = viewModel.getMovie(at: indexPath.row) else { return }
        
        let movieDetailViewController = MovieDetailViewController(movie: selectedMovie)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
