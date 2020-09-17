//
//  ViewController.swift
//  LingvoCam
//
//  Created by Mike Shevelinsky on 13.09.2020.
//  Copyright © 2020 Mike Shevelinsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var outputText: UILabel!
    
    @IBAction func translateDidTap(_ sender: Any) {
        guard let text = inputText.text else { return }
        
        TranslationService.translate(text: text) { (test) in
            DispatchQueue.main.async {
                self.outputText.text = test 
            }
        }
        
        
    }
    
}

