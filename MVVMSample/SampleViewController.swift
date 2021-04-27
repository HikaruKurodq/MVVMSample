//
//  SampleViewController.swift
//  MVVMSample
//
//  Created by HikaruKuroda on 2021/04/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        
        button.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .subscribe(onNext: { text in
                print(text)
            })
            .disposed(by: bag)
    }
}
