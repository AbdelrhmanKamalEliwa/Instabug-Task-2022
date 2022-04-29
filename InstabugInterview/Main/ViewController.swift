//
//  ViewController.swift
//  InstabugInterview
//
//  Created by Yousef Hamza on 1/13/21.
//

import UIKit
import InstabugNetworkClient

class ViewController: UIViewController {
    // MARK: - IBOutlets
    //
    @IBOutlet private weak var getNumberLabel: UILabel!
    @IBOutlet private weak var postNumberLabel: UILabel!
    @IBOutlet private weak var deleteNumberLabel: UILabel!
    @IBOutlet private weak var putNumberLabel: UILabel!
    @IBOutlet private weak var totalNumberLabel: UILabel!
    
    // MARK: - LIFECYCLE
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    //
    @IBAction private func didTapCallAPIsButton(_ sender: UIButton) {
        callAPIs()
    }
    
    @IBAction private func didTapLoadNumbersButton(_ sender: UIButton) {
        getRequestsNumber()
    }
}

// MARK: - PRIVATE METHODS
//
private extension ViewController {
    func callAPIs() {
        guard
            let getURL: URL = .init(string: "https://httpbin.org/get"),
            let postURL: URL = .init(string: "https://httpbin.org/post"),
            let deleteURL: URL = .init(string: "https://httpbin.org/delete"),
            let putURL: URL = .init(string: "https://httpbin.org/put")
        else { return }
        
        for _ in 0 ... 100 {
            /// Print response for each API Call
            NetworkClient.shared.get(getURL) { print("GET:", String(describing: $0)) }
            NetworkClient.shared.post(postURL) { print("POST:", String(describing: $0)) }
            NetworkClient.shared.delete(deleteURL) { print("DELETE:", String(describing: $0)) }
            NetworkClient.shared.delete(putURL) { print("PUT:", String(describing: $0)) }
        }
    }
    
    func getRequestsNumber() {
        getNumberLabel.text = String(NetworkClient.shared.allNetworkRequests().filter { $0.requestMethod == "GET" }.count)
        postNumberLabel.text = String(NetworkClient.shared.allNetworkRequests().filter { $0.requestMethod == "POST" }.count)
        deleteNumberLabel.text = String(NetworkClient.shared.allNetworkRequests().filter { $0.requestMethod == "DELETE" }.count)
        putNumberLabel.text = String(NetworkClient.shared.allNetworkRequests().filter { $0.requestMethod == "PUT" }.count)
        totalNumberLabel.text = String(NetworkClient.shared.allNetworkRequests().count)
    }
}
