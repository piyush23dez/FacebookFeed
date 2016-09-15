//
//  ViewController.swift
//  FacebookFeed
//
//  Created by Sharma, Piyush on 9/11/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

let cellId = "cellId"

class FeedViewController: UICollectionViewController {
    
    var allPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Facebook Feed"
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

extension FeedViewController {
    
    
    func getPosts() -> [Post] {
        allPosts = PostAPI.sharedInstance.getPosts()
        return allPosts
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getPosts().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FeedCell
       
        let allPosts = getPosts()
        feedCell?.post = allPosts[indexPath.item]
        return feedCell!
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = allPosts[indexPath.item].statusText {
            
            //rough estimate of a string
            let rect = NSString(string: statusText).boundingRect(with: CGSize.init(width: view.frame.size.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)], context: nil)
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: knownHeight + rect.height + 24 )
        }
        return CGSize(width: view.frame.width, height: 500)
    }
}

