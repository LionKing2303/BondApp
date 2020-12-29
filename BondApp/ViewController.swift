//
//  ViewController.swift
//  BondApp
//
//  Created by Arie Peretz on 29/12/2020.
//  Copyright © 2020 Arie Peretz. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class DataInput {
    var text: Observable<String?> = Observable<String?>(nil)
    var prefix: Observable<String> = Observable<String>("")
    var phoneNumber: Observable<String> = Observable<String>("")
}

class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var prefix: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    private var input: DataInput = DataInput()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var prefixes = ["054","052","050"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Input Textfield text -> Input Data text
        textfield.reactive
            .text
            .bind(to: input.text)
            .dispose(in: disposeBag)
        
        // Input Data text -> first matching prefix if any -> Input Data prefix
        input.text
            .map { text in
                self.prefixes.first { (prefix) -> Bool in
                    prefix == (text ?? "").prefix(3)
                } ?? ""
            }
            .bind(to: input.prefix)
            .dispose(in: disposeBag)
        
        // Input Data text -> only if we have prefix -> dropping 3 first characters -> Input Data phoneNumber
        input.text
            .filter { text in
                self.input.prefix.value.count > 0
            }
            .map { text in
                String(text?.dropFirst(3) ?? "")
            }
            .bind(to: input.phoneNumber)
            .dispose(in: disposeBag)
        
        // Input Data prefix -> if no text then "no prefix" -> prefix Label
        input.prefix
            .map { text in
                text.count == 0 ? "no prefix" : text
            }
            .map { text in
                "Prefix: \(text)"
            }
            .bind(to: prefix)
            .dispose(in: disposeBag)
        
        // Input Data phoneNumber -> if no text then "no phone number" -> phoneNumber Label
        input.phoneNumber
            .map { text in
                text.count == 0 ? "no phone number" : text
            }
            .map { text in
                "Phone Number: \(text)"
            }
            .bind(to: phoneNumber)
            .dispose(in: disposeBag)
    }
}

