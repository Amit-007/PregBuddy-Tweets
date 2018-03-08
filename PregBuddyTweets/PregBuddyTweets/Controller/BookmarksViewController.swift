//
//  BookmarksViewController.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import UIKit

class BookmarksViewController: UIViewController {

    // MARK: - Lazy Instantiation Of Properties
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TweetsTableViewCell.self, forCellReuseIdentifier: kTweetsTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var bookmarkedTweets: [TweetsList] = {
        let array = [TweetsList]()
        return array
    }()
    
    // MARK: - View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.topItem?.title = "Bookmarks"
        bookmarkedTweets = CoreDataWrapper.shared().fetchTweets()
        self.tableView.reloadData()
    }

}


extension BookmarksViewController{
    
    // MARK: - Private Methods
    
    fileprivate func setupLayout(){
        addUserInterfaceElements()
        applyConstraints()
    }
    
    private func addUserInterfaceElements(){
        view.addSubview(tableView)
    }
    
    private func applyConstraints(){
        
        if #available(iOS 11.0, *) {
            [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
                ].forEach({ $0.isActive = true
                })
        }else{
            [tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ].forEach({ $0.isActive = true
                })
        }
    }
}
