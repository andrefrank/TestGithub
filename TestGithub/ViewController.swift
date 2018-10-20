//
//  ViewController.swift
//  TestGithub
//
//  Created by Andre Frank on 20.10.18.
//  Copyright © 2018 Afapps+. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("This is a git tutorial")
    }

    @IBAction func buttonPressed(_ sender: Any) {
        
        print("A button pressed")
    }
    
    @IBAction func commitButtonPressed(_ sender: Any) {
        
        print("Commit and remote push")
    }
}

