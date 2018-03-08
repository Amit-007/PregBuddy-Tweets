//
//  BookmarksViewController+TableView.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import UIKit



extension BookmarksViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTweetsTableViewCell, for: indexPath) as! TweetsTableViewCell
        cell.selectionStyle = .none
        cell.bookmarkBtn.isHidden = true
        
        let localTweet = bookmarkedTweets[indexPath.row]
        cell.localTweet = localTweet
        if let url = localTweet.media_url{
            cell.mediaImage.isHidden = (url.count == 0) ? true : false
        }
        return cell
    }
    
    
}


extension BookmarksViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let tweet = bookmarkedTweets[indexPath.row]
        var mediaImageHeight: CGFloat = 0
        if let url = tweet.media_url{
            mediaImageHeight = (url.count == 0) ? 0 : 150
        }
        let height = CGFloat((tweet.name?.heightWithConstrainedWidth(width: self.view.frame.width - 110, font: UIFont.helvitaBold(16)))!) + CGFloat((tweet.text?.heightWithConstrainedWidth(width: self.view.frame.width - 110, font: UIFont.helvita(15)))!) + 90 + mediaImageHeight
        
        return height
    }
}
