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
    var onModelSelect: PublishRelay<Repository> { get }
}

protocol RepositoriesViewModelOutputs {
    var repositories: BehaviorRelay<[Repository]> { get }
    var selectedRepository: PublishRelay<Repository> { get }
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
    var onModelSelect = PublishRelay<Repository>()
    
    //MARK: - Outputs
    var repositories = BehaviorRelay<[Repository]>(value: [])
    var selectedRepository = PublishRelay<Repository>()
    
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
        
        onModelSelect
            .bind(to: selectedRepository)
            .disposed(by: bag)
    }

    
}
