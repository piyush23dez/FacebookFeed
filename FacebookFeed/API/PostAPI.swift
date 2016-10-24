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
    
    func fetchPostImage(url: String, completionHandler: @escaping ((Response) -> Void) ) {
        
        if let url = URL.init(string: url)  {
            getData(url: url, completionHandler: { (result) in
                completionHandler(result)
            })
        }
    }
    
    func saveImage(image: UIImage, key: NSString) {
        dataManager?.saveImage(image: image, key: key)
    }
    
    func getCachedImage(key: NSString) -> UIImage? {
        return dataManager?.getCachedImage(key: key)
    }

    func getData(url: URL, completionHandler: @escaping ((Response) -> Void)) {
        httpClient.sendRequest(requestUrl: url) { (result) in
            
            switch result {
            case .Success(let data):
                completionHandler(data)
            case .Failure(let errorData):
                if let errorString  = errorData as? String {
                    completionHandler(errorString)
                }
                else {
                    if let errorJson = try? JSONSerialization.jsonObject(with: errorData as! Data) as? Dictionary<String, Any> {
                        if let errorDesc = errorJson?["error"] as? String {
                            completionHandler(errorDesc)
                        }
                    }
                }
            }
        }
    }
}
