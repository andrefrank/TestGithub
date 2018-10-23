//
//  ViewController.swift
//  TestGithub
//
//  Created by Andre Frank on 20.10.18.
//  Copyright © 2018 Afapps+. All rights reserved.
//

import UIKit


class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("This is a git tutorial")
    }

    @IBAction func buttonPressed(_ sender: Any) {
        
        print("A button pressed")
    }
    
    @IBAction func commitButtonPressed(_ sender: Any) {
    
        var messages=[Message]()
        for i in 0...4{
            let newMessage = Message(title: "Message \(i)", body: "with text body")
            messages.append(newMessage)
        }
        
        do{
            try Storage.shared.save(object: messages, to: Storage.StorageDirectoryType.caches, as: "messages.json")
        }catch let storageError as Storage.StorageError{
            
            print(storageError.errorDescription)
            
        }catch let error{
            print(error.localizedDescription)
        }
        
        sleep(3)
        
        do{
            let loadMessages = try Storage.shared.load("messages.json", from: Storage.StorageDirectoryType.caches, as: [Message].self)
            print(loadMessages)
            
        }catch let storageError as Storage.StorageError{
            
            print(storageError.errorDescription)
            
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
}




