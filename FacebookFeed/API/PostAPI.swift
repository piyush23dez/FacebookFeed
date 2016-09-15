//
//  PostAPI.swift
//  FacebookFeed
//
//  Created by Sharma, Piyush on 9/14/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation
import UIKit

enum Result<T, E> {
    case Success(data: T?)
    case Failure(error: E?)
}

enum APIError: Error {
    case NetworkError
    case UnknownError
}

protocol Fetchable {
    associatedtype Response
    func getData(url: URL, completionHandler: ((Response) -> Void))
}

class PostAPI: Fetchable {
   
    typealias Response = Any
  
    private var httpClient: HttpClient
    private var dataManager: DataManager?
    static var sharedInstance = PostAPI()
    
    private init() {
        httpClient = HttpClient()
        dataManager = DataManager()
    }
    
    func getPosts()-> [Post] {
        return dataManager!.getPosts()
    }
    
    func fetchPostImage(url: String, completionHandler: ((Any) -> Void) ) {
        
        if let url = URL.init(string: url)  {
            getData(url: url, completionHandler: { (result) in
                completionHandler(result)
            })
        }
    }

    internal func getData(url: URL, completionHandler: ((Any) -> Void)) {
        httpClient.sendRequest(requestUrl: url) { (result) in
            
            switch result {
            case .Success(let data):
                completionHandler(data)
            case .Failure(let error):
                completionHandler(error)
            }
        }
    }
}
