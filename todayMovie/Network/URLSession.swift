//
//  URLSession.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/10/29.
//

import Foundation
import UIKit

func fetchData() {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let tmdbAPIKey = "e3269631c1a855227a37cefab44ad995"
    let urlString = "https://api.themoviedb.org/3/movie/157336?api_key=\(tmdbAPIKey)&append_to_response=videos"

    if let url = URL(string: urlString) {
        let task = session.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                if let data = data {
                    if let result = String(data: data, encoding: .utf8) {
                        print(result)
                    }
                }
            } else {
                print("--> response \(response)")
            }
        }
        task.resume()
    } else {
        print("Invalid URL")
    }
}




