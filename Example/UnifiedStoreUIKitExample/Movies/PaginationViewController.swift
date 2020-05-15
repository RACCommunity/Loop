import UIKit
import ReactiveSwift
import ReactiveCocoa
import Loop

// Key for https://www.themoviedb.org API
let correctKey = "d4f0bdb3e246e2cb3555211e765c89e3"

struct Results: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]

    static func empty() -> Results {
        return Results.init(page: 0, totalResults: 0, totalPages: 0, results: [])
    }

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct Movie: Codable {
    let id: Int
    let overview: String
    let title: String
    let posterPath: String?

    var posterURL: URL? {
        return posterPath
            .map {
                "https://image.tmdb.org/t/p/w342/\($0)"
            }
            .flatMap(URL.init(string:))
    }

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case title
        case posterPath = "poster_path"
    }
}

extension URLSession {
    func fetchMovies(page: Int) -> SignalProducer<Results, NSError> {
        return SignalProducer.init({ (observer, lifetime) in
            let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(correctKey)&sort_by=popularity.desc&page=\(page)")!
            let task = self.dataTask(with: url, completionHandler: { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    let error = NSError(domain: "come.reactivefeedback",
                                        code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Forced failure to illustrate Retry"])
                    observer.send(error: error)
                } else if let data = data {
                    do {
                        let results = try JSONDecoder().decode(Results.self, from: data)
                        observer.send(value: results)
                    } catch {
                        observer.send(error: error as NSError)
                    }
                } else if let error = error {
                    observer.send(error: error as NSError)
                    observer.sendCompleted()
                } else {
                    observer.sendCompleted()
                }
            })

            lifetime += AnyDisposable(task.cancel)
            task.resume()
        })
    }
}
