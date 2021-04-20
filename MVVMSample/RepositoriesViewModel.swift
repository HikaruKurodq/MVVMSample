//
//  ViewModel.swift
//  MVVMSample
//
//  Created by HikaruKuroda on 2021/04/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol RepositoriesViewModelInputs {
    var onSearchButtonClick: PublishRelay<Void> { get }
    var searchWord: PublishRelay<String> { get }
}

protocol RepositoriesViewModelOutputs {
    var repositories: BehaviorSubject<[Repository]> { get }
}

protocol RepositoriesViewModelType {
    var inputs: RepositoriesViewModelInputs { get }
    var outputs: RepositoriesViewModelOutputs { get }
}

class RepositoriesViewModel: RepositoriesViewModelType, RepositoriesViewModelInputs, RepositoriesViewModelOutputs {
    
    var inputs: RepositoriesViewModelInputs { return self }
    var outputs: RepositoriesViewModelOutputs { return self }
    
    //MARK: - Inputs
    var onSearchButtonClick = PublishRelay<Void>()
    var searchWord = PublishRelay<String>()
    
    //MARK: - Outputs
    var repositories = BehaviorSubject<[Repository]>(value: [])
    
    private let model = GitHubModel()
    private let bag = DisposeBag()
    
    init() {
        
        onSearchButtonClick
            .withLatestFrom(searchWord)
            .flatMap{ [unowned self] searchWord -> Observable<[Repository]> in
                model.searchRepositories(with: searchWord)
            }
            .bind(to: repositories)
            .disposed(by: bag)
        
    }

    
}
