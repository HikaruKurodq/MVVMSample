//
//  ViewController.swift
//  MVVMSample
//
//  Created by HikaruKuroda on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    private var viewModel = RepositoriesViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let outputs = viewModel
            .transform(input: RepositoriesViewModel.Input(onSearchButtonClick: searchBar.rx
                                                            .searchButtonClicked
                                                            .asSignal(),
                                                          searchWord: searchBar.searchTextField.rx
                                                            .text.orEmpty
                                                            .asDriver(),
                                                          onModelSelect: repositoriesTableView.rx
                                                            .modelSelected(Repository.self)
                                                            .asSignal()
            ))
        
        outputs.repositories.drive(repositoriesTableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
            cell.textLabel?.text = element.full_name
        }
        .disposed(by: bag)
        
        outputs.selectedRepositoryURL
            .emit{ UIApplication.shared.open($0, options: [:], completionHandler: nil) }
            .disposed(by: bag)

        
        
    }
    
}

