//
//  DataManager.swift
//  FacebookFeed
//
//  Created by Sharma, Piyush on 9/14/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation
import UIKit

class DataManager: NSObject {

    var imageCache = NSCache<NSString, AnyObject>()

    private var posts = [Post]()
    
    override init() {
        
        let postMark = Post()
        postMark.name = "Mark Zuckerberg"
        postMark.profileImageName = "zuckprofile"
        postMark.statusText = "By giving people the power to share, we're making the world more transparent."
        postMark.statusImageName = "mark_zuckerberg_background"
        postMark.numLikes = 400
        postMark.numComments = 123
        postMark.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/mark_zuckerberg_background.jpg"
        
        let postSteve = Post()
        postSteve.name = "Steve Jobs"
        postSteve.profileImageName = "steve_profile"
        postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
            "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" +
        "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
        postSteve.statusImageName = "steve_status"
        postSteve.numLikes = 1000
        postSteve.numComments = 55
        postSteve.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/steve_jobs_background.jpg"
        
        let postGandhi = Post()
        postGandhi.name = "Mahatma Gandhi"
        postGandhi.profileImageName = "gandhi_profile"
        postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" +
            "The weak can never forgive. Forgiveness is the attribute of the strong.\n" +
        "Happiness is when what you think, what you say, and what you do are in harmony."
        postGandhi.statusImageName = "gandhi_status"
        postGandhi.numLikes = 333
        postGandhi.numComments = 22
        postGandhi.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gandhi_status.jpg"
        
        let postBillGates = Post()
        postBillGates.name = "Bill Gates"
        postBillGates.profileImageName = "bill_gates_profile"
        postBillGates.statusText = "Success is a lousy teacher. It seduces smart people into thinking they can't lose.\n\n" +
            "Your most unhappy customers are your greatest source of learning.\n\n" +
        "As we look ahead into the next century, leaders will be those who empower others."
        postBillGates.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gates_background.jpg"
        
        let postTimCook = Post()
        postTimCook.name = "Tim Cook"
        postTimCook.profileImageName = "tim_cook_profile"
        postTimCook.statusText = "The worst thing in the world that can happen to you if you're an engineer that has given his life to something is for someone to rip it off and put their name on it."
        postTimCook.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/Tim+Cook.png"
        
        let postDonaldTrump = Post()
        postDonaldTrump.name = "Donald Trump"
        postDonaldTrump.profileImageName = "donald_trump_profile"
        postDonaldTrump.statusText = "An ‘extremely credible source’ has called my office and told me that Barack Obama’s birth certificate is a fraud."
        postDonaldTrump.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/trump_background.jpg"
        
        posts = [postMark, postSteve, postGandhi, postBillGates, postTimCook, postDonaldTrump]
    }
    
    func saveImage(image: UIImage, key: NSString) {
      //Save image in disk or cache
        imageCache.setObject(image, forKey: key)
    }
    
    func getCachedImage(key: NSString) -> UIImage? {
        
        if let cachedImage = imageCache.object(forKey: key) as? UIImage {
            return cachedImage
        }
        return nil
    }
    
    func getPosts() -> [Post] {
        return posts
    }
    
    func getPost(index: Int) -> Post {
        return posts[index]
    }
}
