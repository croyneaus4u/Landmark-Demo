//
//  BaseRequestor.swift
//  LithiumDemo
//
//  Copyright © 2016 Lab kumar. All rights reserved.
//  Created by Lab kumar on 08/11/16.



import Foundation
import HTMLReader

enum RequestMethodType: String {
    case GET = "GET", POST = "POST", PUT = "PUT", DELETE = "DELETE"
}

typealias NetworkSuccessHandler = (Any?) -> Void
typealias NetworkFailureHandler = (Error?) -> Void
typealias NetworkCompletionHandler = (_ success: Bool, _ object: Any?) -> Void

class BaseRequestor: NSObject {
    
    let requestOperationQueue = OperationQueue()
    var dataTask: URLSessionDataTask?
    
    override init() {
        //
    }
    
    func defaultHeaders () -> [String: String] {
        return ["Accept" : "application/json"]
    }
    
    // Generic request
    func makeRequestWithparameters (method: RequestMethodType, urlString: String, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {
        
        print("\nRequestHeaders:>> \(defaultHeaders())")
        print("\nRequestURL:>> \(urlString)")
        
        guard let url = URL(string: urlString) else {
            failure?(nil)
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders()
        request.httpMethod = method.rawValue
        
        dataTask = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    failure?(error)
                } else if let _ = data, let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    let string = String(data: data!, encoding: .utf8)
                    success?(string)
                } else {
                    failure?(nil)
                }
            }
        }
        
        dataTask?.resume()
    }
    
    // make GET Request
    func makeGETRequestWithparameters (urlString: String, success: NetworkSuccessHandler?, failure: NetworkFailureHandler?) {

        makeRequestWithparameters(method: .GET, urlString: urlString, success: success, failure: failure)
    }
}
