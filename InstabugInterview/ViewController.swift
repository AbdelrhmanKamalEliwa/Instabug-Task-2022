//
//  ViewController.swift
//  InstabugInterview
//
//  Created by Yousef Hamza on 1/13/21.
//

import UIKit
import InstabugNetworkClient

class ViewController: UIViewController {
    
    lazy var networkClient: NetworkClient = {
        NetworkClient.shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard
            let getURL = URL(string: "https://httpbin.org/get"),
            let postURL = URL(string: "https://httpbin.org/post")
        else { return }
        for _ in 0..<201 {
            networkClient.get(getURL) { [weak self] response in
                print(response)
            }
            
            networkClient.post(postURL) { [weak self] response in
                print(response)
            }
        }
    }
}

