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
    
    private var viewModel: RepositoriesViewModelType!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RepositoriesViewModel()
        
        searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputs.onSearchButtonClick)
            .disposed(by: bag)
        
        searchBar.searchTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.searchWord)
            .disposed(by: bag)
        
        viewModel.outputs.repositories
            .bind(to: repositoriesTableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
                cell.textLabel?.text = element.full_name
            }
            .disposed(by: bag)
        
    }
}

