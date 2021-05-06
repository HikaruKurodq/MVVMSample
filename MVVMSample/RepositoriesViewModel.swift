//
//  ViewModel.swift
//  MVVMSample
//
//  Created by HikaruKuroda on 2021/04/20.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoriesViewModel {
    
    public struct Input {
        var onSearchButtonClick: Signal<Void>
        var searchWord: Driver<String>
        var onModelSelect: Signal<Repository>
    }
    
    public struct Output {
        var repositories: Driver<[Repository]>
        var selectedRepositoryURL: Signal<URL>
    }
    
    private let model = GitHubModel()
    private let bag = DisposeBag()
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        let repositories = input.onSearchButtonClick
            .withLatestFrom(input.searchWord)
            .flatMap{ [unowned self] in model.searchRepositories(with: $0).asDriver(onErrorJustReturn: []) }
            
        let selectedRepositoryURL = input.onModelSelect
            .map{ URL(string: $0.html_url)! }
            .asSignal(onErrorSignalWith: .empty())
        
        return Output(repositories: repositories,
                      selectedRepositoryURL: selectedRepositoryURL)
    }
}





