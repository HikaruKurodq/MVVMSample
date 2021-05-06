//
//  Model.swift
//  MVVMSample
//
//  Created by HikaruKuroda on 2021/04/20.
//

import Foundation
import RxSwift
import RxCocoa

class GitHubModel {
    
    func searchRepositories(with searchWord: String) -> Observable<[Repository]> {
        return Observable.create { (observer) -> Disposable in
            
            let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)&sort=stars")!
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
                guard let data = data else { return }
                do {
                    let apiResult = try JSONDecoder().decode(GitHubAPIResult.self, from: data)
                    let items = apiResult.items
                    observer.onNext(items)
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create()
        }
    }
    
}

struct GitHubAPIResult: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let full_name: String
    let html_url: String
}
