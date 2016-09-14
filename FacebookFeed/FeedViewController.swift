//
//  ViewController.swift
//  FacebookFeed
//
//  Created by Sharma, Piyush on 9/11/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

let cellId = "cellId"


class Post {
    var name: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var numLikes: Int?
    var numComments: Int?
}


class FeedViewController: UICollectionViewController {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let markPost = Post()
        markPost.name = "Mark Zukerberg"
        markPost.statusText = "By giving people the power to share, we're making the world more transparent."
        markPost.profileImageName = "zuckprofile"
        markPost.statusImageName = "zuckdog"
        markPost.numLikes = 400
        markPost.numComments = 123
        
        let postSteve = Post()
        postSteve.name = "Steve Jobs"
        postSteve.profileImageName = "steve_profile"
        postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
            "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" +
        "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
        postSteve.statusImageName = "steve_status"
        postSteve.numLikes = 1000
        postSteve.numComments = 55


        let postGandhi = Post()
        postGandhi.name = "Mahatma Gandhi"
        postGandhi.profileImageName = "gandhi_profile"
        postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" +
            "The weak can never forgive. Forgiveness is the attribute of the strong.\n" +
        "Happiness is when what you think, what you say, and what you do are in harmony."
        postGandhi.statusImageName = "gandhi_status"
        postGandhi.numLikes = 333
        postGandhi.numComments = 22

        
        posts.append(markPost)
        posts.append(postSteve)
        posts.append(postGandhi)

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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FeedCell
        feedCell?.post = posts[indexPath.item]
        return feedCell!
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText {
            
            //rough estimate of a string
            let rect = NSString(string: statusText).boundingRect(with: CGSize.init(width: view.frame.size.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)], context: nil)
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: knownHeight + rect.height + 24 )
        }
        return CGSize(width: view.frame.width, height: 500)
    }
}

class FeedCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post: Post? {
        
        didSet {
            if let name = post?.name {
                //1.Title
                let title = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
                
                //2.Subtitle
                let subTitle = NSMutableAttributedString(string: "\nDecember 18  •  San Francisco  •  ", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor.rgb(red: 155, green: 161, blue: 171)])
                
                //3.Title+Subtitle
                title.append(subTitle)
                
                //4.Create ParagraphStyle
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                //5.Add ParagraphStyle
                title.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, title.string.characters.count))
                
                //6.Create an image attachement
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "globe_small")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                
                //7.Create Attributed atring of attachment
                let attachmentAttributedString = NSAttributedString(attachment: imageAttachment)
                
                //8.Append attachment attributed string
                title.append(attachmentAttributedString)
                nameLabel.attributedText = title
            }
            
            if let status = post?.statusText {
                statusTextView.text = status
            }
            
            if let profileImage = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImage)
            }
            
            if let statusImage = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImage)
            }
            
            if let likes = post?.numLikes, let comments = post?.numComments {
                likesCommentsLabel.text = "\(likes) Likes    \(comments) Comments"
            }
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
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String : UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
}
