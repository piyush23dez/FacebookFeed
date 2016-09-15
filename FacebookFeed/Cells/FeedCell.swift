//
//  FeedCell.swift
//  FacebookFeed
//
//  Created by Sharma, Piyush on 9/14/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit
import Foundation

var imageCache = NSCache<NSString, AnyObject>()

class FeedCell: UICollectionViewCell {
    
    var loader: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post: Post? {
        
        didSet {
            
            statusImageView.image = nil
            if let statusImageUrl: String = post?.statusImageUrl {
                
                if let cachedImage = imageCache.object(forKey: statusImageUrl as NSString) as? UIImage {
                    statusImageView.image = cachedImage
                    loader?.stopAnimating()
                }
                else {
                    PostAPI.sharedInstance.fetchPostImage(url: post!.statusImageUrl!) { (result) in
                        
                        if let imageData = result as? Data {
                            if let statusImage = UIImage(data: imageData) {
                                
                                imageCache.setObject(statusImage, forKey: statusImageUrl as NSString)
                                DispatchQueue.main.async {
                                    self.statusImageView.image = statusImage
                                    self.loader?.stopAnimating()
                                }
                            }
                        }
                        else {
                            print(result as? APIError)
                        }
                    }
                }
                
            }
            setupPost()
        }
    }
    
    func setupPost() {
        if let name = post?.name {
            
            //1.Title mutable attributed string
            let title = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
            
            //2.Subtitle mutable attributed string
            let subTitle = NSMutableAttributedString(string: "\nDecember 18  •  San Francisco  •  ", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor.rgb(red: 155, green: 161, blue: 171)])
            
            //3.Title+Subtitle
            title.append(subTitle)
            
            //4.Create mutable paragraph style
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            //5.Add paragraph style as an attribute to title string
            title.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, title.string.characters.count))
            
            //6.Create an image attachement
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "globe_small")
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            
            //7.Create attributed string of image attachment
            let attachmentAttributedString = NSAttributedString(attachment: imageAttachment)
            
            //8.Append attachment attributed string to title
            title.append(attachmentAttributedString)
            nameLabel.attributedText = title
        }
        
        if let status = post?.statusText {
            statusTextView.text = status
        }
        
        if let profileImage = post?.profileImageName {
            profileImageView.image = UIImage(named: profileImage)
        }
        
        if let likes = post?.numLikes, let comments = post?.numComments {
            likesCommentsLabel.text = "\(likes) Likes    \(comments) Comments"
        }
    }
    
    var profileImageView: UIImageView  = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "zuckprofile")
        return imageView
    }()
    
    var nameLabel: UILabel  = {
        
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    var statusTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    var statusImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        
        //fit image in its superview bounds by masking
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 155, green: 166, blue: 171)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    
    var likeButton = FeedCell.buttonFor(title: "Like", imageName: "like")
    var commentButton = FeedCell.buttonFor(title: "Comment", imageName: "comment")
    var shareButton = FeedCell.buttonFor(title: "Share", imageName: "share")
    
    static func buttonFor(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }
    
    func setupViews() {
        self.backgroundColor = UIColor.white
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLine)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        setupLoader()
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentsLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLine)
        
        addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton,commentButton,shareButton)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.5)][v5(44)]|", views: profileImageView, statusTextView,statusImageView,likesCommentsLabel,dividerLine,likeButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
    }
    
    func setupLoader() {
        loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader?.hidesWhenStopped = true
        loader?.startAnimating()
        statusImageView.addSubview(loader!)
        
        statusImageView.addConstraintsWithFormat(format: "H:|[v0]|", views: loader!)
        statusImageView.addConstraintsWithFormat(format: "V:|[v0]|", views: loader!)
    }
}
