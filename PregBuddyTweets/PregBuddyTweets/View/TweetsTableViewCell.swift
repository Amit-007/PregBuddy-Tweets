//
//  TweetsTableViewCell.swift
//  PregBuddy Tweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//

import UIKit
import SDWebImage

class TweetsTableViewCell: UITableViewCell {

    var tweet: Tweet?{
        didSet{
            guard let safeTweet = tweet else {
                return
            }
            screenName.text = "@\(safeTweet.screen_name!)"
            name.text = safeTweet.name
            if safeTweet.profile_image_url?.count != 0{
                profileImage.sd_setImage(with: URL(string: safeTweet.profile_image_url!), placeholderImage: UIColor.twitter.imageRepresentation)
            }
            tweetedText.text = safeTweet.text
            if safeTweet.media_url?.count != 0 {
                mediaImage.sd_setImage(with: URL(string: safeTweet.media_url!), placeholderImage: UIColor.twitter.imageRepresentation)
            }
            
        }
    }
    var localTweet: TweetsList?{
       
        didSet{
            guard let safeTweet = localTweet else {
                return
            }
            screenName.text = "@\(safeTweet.screen_name!)"
            name.text = safeTweet.name
            if safeTweet.profile_image_url?.count != 0{
                profileImage.sd_setImage(with: URL(string: safeTweet.profile_image_url!), placeholderImage: UIColor.twitter.imageRepresentation)
            }
            tweetedText.text = safeTweet.text
            if safeTweet.media_url?.count != 0 {
                mediaImage.sd_setImage(with: URL(string: safeTweet.media_url!), placeholderImage: UIColor.twitter.imageRepresentation)
            }
            
        }
    }
    
    private lazy var customBackgroundView: UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var name: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.helvitaBold(14)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var screenName: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.helvitaBold(14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIColor.twitter.imageRepresentation
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
     lazy var mediaImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tweetedText: UITextView = {
       
        let textView = UITextView()
        textView.textColor = .black
        textView.textAlignment = .justified
        textView.font = UIFont.helvita(15.0)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var bookmarkBtn: UIButton = {
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "bookmark"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "bookmark"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayout()
    }
    
    
    private func setUpLayout(){
       
        addSubview(customBackgroundView)
        customBackgroundView.addSubview(profileImage)
        customBackgroundView.addSubview(name)
        customBackgroundView.addSubview(screenName)
        customBackgroundView.addSubview(tweetedText)
        customBackgroundView.addSubview(mediaImage)
        customBackgroundView.addSubview(bookmarkBtn)
        
        customBackgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        customBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        customBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        customBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 20).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 20).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        name.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 20).isActive = true
        name.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 25).isActive = true
        name.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        
        screenName.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 20).isActive = true
        screenName.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 2).isActive = true
        screenName.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -20).isActive = true
        
        tweetedText.topAnchor.constraint(equalTo: screenName.bottomAnchor, constant: 0).isActive = true
        tweetedText.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20).isActive = true
        tweetedText.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -20).isActive = true
        
        mediaImage.topAnchor.constraint(equalTo: tweetedText.bottomAnchor, constant: 10).isActive = true
        mediaImage.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 90).isActive = true
        mediaImage.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -20).isActive = false
        mediaImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        mediaImage.widthAnchor.constraint(equalToConstant: 250).isActive = true

        mediaImage.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor, constant: -20).isActive = false
        
        bookmarkBtn.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        bookmarkBtn.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 20).isActive = true
        bookmarkBtn.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        bookmarkBtn.widthAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        


    }
    
}
