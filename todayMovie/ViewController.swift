//
//  ViewController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/28.
//

// data fetch -> data parsing -> display data -> segue -> ui interaction
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
          button.addTarget(self, action: #selector(fetchDataButtonPressed), for: .touchUpInside)
          return button
      }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(fetchDataButton)
        fetchDataButton.frame = CGRect(x: 100, y: 400, width: 200, height: 40)
        
    }

    @objc func fetchDataButtonPressed() {
        fetchData()
    }

    func fetchData() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let tmdbAPIKey = "e3269631c1a855227a37cefab44ad995"
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(tmdbAPIKey)&language=ko-KR&append_to_response=videos"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("--> response \(String(describing: response))")
                return
            }

            guard let data = data, let result = String(data: data, encoding: .utf8) else {
                return
            }

            print("Movie result:", result)
        }

        task.resume()
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
