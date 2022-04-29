//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

public class NetworkClient {
    public static var shared = NetworkClient()

    private var networkLoggerManager: NetworkLoggerManagerContract?
    
    public func configureNetworkLoggerManager() {
        self.networkLoggerManager = NetworkLoggerManager()
    }
    
    // MARK: Network requests
    public func get(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
    }

    public func post(_ url: URL, payload: Data? = nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "POST", payload: payload, completionHandler: completionHandler)
    }

    public func put(_ url: URL, payload: Data? = nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
    }

    public func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
    }

    func executeRequest(_ url: URL, method: String, payload: Data?, completionHandler: @escaping (Data?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = payload
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            let networkLoggerData: LogDataModel = .init(
                domainError: error?.localizedDescription,
                errorCode: (error as NSError?)?.code,
                requestMethod: method,
                requestPayload: payload,
                requestURL: url.absoluteString,
                responsePayload: data,
                responseStatusCode: httpResponse.statusCode
            )
            
            self.saveLog(networkLoggerData)
            
            DispatchQueue.main.async {
                completionHandler(data)
            }
        }.resume()
    }

    // MARK: Network recording
    public func allNetworkRequests() -> [LogDataModel] {
        guard let networkLoggerManager = networkLoggerManager else {
            fatalError("Network logger manager must be initialized")
        }
        
        return networkLoggerManager.fetchLogsData()
    }
}

private extension NetworkClient {
    func saveLog(_ log: LogDataModel) {
        guard let networkLoggerManager = networkLoggerManager else {
            fatalError("Network logger manager must be initialized")
        }
        
        networkLoggerManager.saveLog(log)
    }
}
