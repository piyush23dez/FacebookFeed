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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
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
    
    var profileImageView: UIImageView  = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "zuckprofile")
        return imageView
    }()
    
    var nameLabel: UILabel  = {
        
        let label = UILabel()
        label.numberOfLines = 2
        
        //1.Title
        let title = NSMutableAttributedString(string: "Mark Zukerberg", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
        
        //2.Subtitle
        let subTitle = NSMutableAttributedString(string: "\nDecember 18  •  San Francisco  •  ", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)])
        
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
        label.attributedText = title

        return label
    }()
    
    var statusTextView: UITextView = {
       let textView = UITextView()
        textView.text = "Meanwhile, Beast turned into dark side."
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
    
    func setupViews() {
        self.backgroundColor = UIColor.white
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(statusTextView)
        addSubview(statusImageView)

        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)

        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1(30)]-4-[v2]|", views: profileImageView, statusTextView,statusImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]", views: nameLabel)
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
