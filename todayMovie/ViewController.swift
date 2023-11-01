//
//  ViewController.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/28.
//

import UIKit

class ViewController: UIViewController {
    
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
        let urlString = "https://api.themoviedb.org/3/movie/157336?api_key=\(tmdbAPIKey)&append_to_response=videos"
        
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

    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let movie = movies[indexPath.row]
            cell.textLabel?.text = movie.title
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "ShowDetailSegue", sender: self)
        }
        
        
        struct Movie: Codable {
            let id: Int
            let title: String
            let overview: String
            let releaseDate: String
            let voteAverage: Double
            let voteCount: Int
            let backdropPath: String?
            let posterPath: String?
            let homepage: String?
            let genres: [Genre]
            let productionCompanies: [ProductionCompany]
            let productionCountries: [ProductionCountry]
            let spokenLanguages: [SpokenLanguage]
            let videos: Videos
            
            struct Genre: Codable {
                let id: Int
                let name: String
            }
            
            struct ProductionCompany: Codable {
                let id: Int
                let name: String
                let originCountry: String
            }
            
            struct ProductionCountry: Codable {
                let iso3166_1: String
                let name: String
            }
            
            struct SpokenLanguage: Codable {
                let englishName: String
                let iso639_1: String
                let name: String
            }
            
            struct Videos: Codable {
                let results: [Video]
                
                struct Video: Codable {
                    let name: String
                    let key: String
                    let site: String
                    let type: String
                    let official: Bool
                }
            }
        }
        
        
    }

