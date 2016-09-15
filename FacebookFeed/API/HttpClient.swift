//
//  HttpClient.swift
//  FacebookFeed
//
//  Created by Sharma, Piyush on 9/14/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation

class HttpClient {
    
    private var sessionConfig = URLSessionConfiguration.default
    private var session: URLSession {
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 30
        return URLSession(configuration: sessionConfig)
    }
    
    func sendRequest(requestUrl: URL, completionHandler: ((Result<Data, APIError>) -> Void)) {
        
        let task = session.dataTask(with: requestUrl) { (data, response, error) in
            
            var statusCode: Int?
            if let response = response as? HTTPURLResponse {
                statusCode = response.statusCode
            }
            
            if statusCode == 200 {
                if let data = data {
                    completionHandler(Result.Success(data: data))
                }
                else {
                    completionHandler(Result.Success(data: nil))
                }
            }
            else {
                if error != nil {
                    completionHandler(Result.Failure(error: .NetworkError))
                }
                else {
                    completionHandler(Result.Failure(error: .UnknownError))
                }
            }
        }
        
        task.resume()
    }
}
