//
//  PostAPI.swift
//  FacebookFeed
//
//  Created by Sharma, Piyush on 9/14/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation


enum Result<T, E> {
    case Success(data: T)
    case Failure(error: E)
}

enum APIError: Error {
    case NetworkError
    case UnknownError
}

protocol Fetchable {
    associatedtype Data
    func getData(completionHandler: ((_ result:Result<Data, Error>) -> Void))
}


class PostAPI: Fetchable {
    
    typealias Data = [Post]
    typealias CompletionHandler = ((_ result: Result<Data, Error>) -> Void)

    private var httpClient: HttpClient
    private var dataManager: DataManager?
    
    private static var sharedInstance = DataManager()
    
    private init() {
        httpClient = HttpClient()
        dataManager = DataManager()
    }
    
    func getPosts()-> [Post] {
        return dataManager!.getPosts()
    }
    
    func getData(completionHandler: CompletionHandler) {
        
    }
}
