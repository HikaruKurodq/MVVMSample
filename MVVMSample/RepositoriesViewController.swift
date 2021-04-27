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
        
        //MARK: - Bind inputs
        searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputs.onSearchButtonClick)
            .disposed(by: bag)

        searchBar.searchTextField.rx.text.orEmpty
            .bind(to: viewModel.inputs.searchWord)
            .disposed(by: bag)
        
        repositoriesTableView.rx
            .modelSelected(Repository.self)
            .bind(to: viewModel.inputs.onModelSelect)
            .disposed(by: bag)
        
        //MARK: - Bind outputs
        viewModel.outputs.repositories
            .bind(to: repositoriesTableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
                cell.textLabel?.text = element.full_name
            }
            .disposed(by: bag)
        
        viewModel.outputs.selectedRepository
            .bind { [unowned self] selectedRepository in
                showDetail(repository: selectedRepository)
            }
            .disposed(by: bag)
        
    }
    
    private func showDetail(repository: Repository) {
        guard let url = URL(string: repository.html_url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

