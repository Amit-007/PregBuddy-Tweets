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
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kTweetsTableViewCell, for: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets[indexPath.row]
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
        let height = CGFloat((tweet.name?.heightWithConstrainedWidth(width: self.view.frame.width - 110, font: UIFont.helvitaBold(16)))!) + CGFloat((tweet.text?.heightWithConstrainedWidth(width: self.view.frame.width - 110, font: UIFont.helvita(15)))!) + 50 + 190
        
        return height
    }
}

