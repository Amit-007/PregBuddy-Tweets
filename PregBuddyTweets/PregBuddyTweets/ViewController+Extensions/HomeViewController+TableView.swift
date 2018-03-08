//
//  HomeViewController+TableView.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import UIKit


extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("COUNT ******** \(tweets.count)")
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTweetsTableViewCell, for: indexPath) as! TweetsTableViewCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        if let url = tweet.media_url{
            cell.mediaImage.isHidden = (url.count == 0) ? true : false
        }
        cell.bookmarkBtn.addTarget(self, action: #selector(HomeViewController.bookmarkAction(button:withEvent:)), for: .touchUpInside)

        cell.selectionStyle = .none
        return cell
    }    
}


extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let tweet = tweets[indexPath.row]
        var mediaImageHeight: CGFloat = 0
        if let url = tweet.media_url{
            mediaImageHeight = (url.count == 0) ? 0 : 150
        }
        let height = CGFloat((tweet.name?.heightWithConstrainedWidth(width: self.view.frame.width - 110, font: UIFont.helvitaBold(16)))!) + CGFloat((tweet.text?.heightWithConstrainedWidth(width: self.view.frame.width - 110, font: UIFont.helvita(15)))!) + 90 + mediaImageHeight
        
        return height
    }
}

