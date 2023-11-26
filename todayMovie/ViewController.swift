//
//  ViewController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/28.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Movie] = []
    
    let fetchDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fetch Data", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        // todo : self warning 고치면 Terminating app due to uncaught exception 'NSInvalidArgumentException
        button.addTarget(ViewController.self, action: Selector(("fetchDataButtonPressed")), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(fetchDataButton)
        fetchDataButton.frame = CGRect(x: 100, y: 400, width: 200, height: 40)
    }

    func fetchDataButtonPressed(
        endpoint: URLRequestConfigurable
    ) {
        let tmdbAPIKey = "e3269631c1a855227a37cefab44ad995"
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(tmdbAPIKey)&language=ko-KR&append_to_response=videos"

        let networkClient = NetworkClient()
        do {
            let urlRequest = try endpoint.asURLRequest()
        } catch {
            print("Error creating URLRequest: \(error)")
        }

        networkClient.request(endpoint: endpoint) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleFetchResult(result.mapError { _ in NetworkManagerError.unknown })
            }
        }
    }

    private func handleFetchResult(_ result: Result<Model, NetworkManagerError>) {
        switch result {
        case .success(_): break
        case .failure(let error):
            DispatchQueue.main.async {
                AlertManager.showErrorAlert(in: self, "박스오피스", error)
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
