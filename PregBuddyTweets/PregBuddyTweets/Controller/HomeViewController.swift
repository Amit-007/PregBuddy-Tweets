//
//  HomeViewController.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import UIKit

class HomeViewController: UIViewController {

    // MARK: - Lazy Instantiation Of Properties
    
    lazy var tableView: UITableView = {
       
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TweetsTableViewCell.self, forCellReuseIdentifier: kTweetsTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        footer.addSubview(loader)
        loader.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
        tableView.tableFooterView = footer
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var tweets: [Tweet] = {
        let array = [Tweet]()
        return array
    }()
    
    fileprivate lazy var segmentControlContainerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var loader: UIActivityIndicatorView = {
       
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.white)
        activityIndicator.color = .twitter
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    fileprivate lazy var segmentControl: UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl(items: ["Most Liked", "Most Retweeted"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    @objc func filterChanged(_ segmentedControl: UISegmentedControl){
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            TwitterWrapper.shared().fetchTweets(.liked, completion: { (tweets, error) in
               
                if error == nil{
                    DispatchQueue.main.async(execute: {
                        guard let safeTweets = tweets else {
                            return
                        }
                        self.tweets = safeTweets
                        self.tableView.reloadData()
                    })
                }else{
                    self.showMessage((error?.localizedDescription)!)
                }
            })
            break
        case 1:
            TwitterWrapper.shared().fetchTweets(.retweeted, completion: { (tweets, error) in
               
                if error == nil{
                    DispatchQueue.main.async(execute: {
                        guard let safeTweets = tweets else {
                            return
                        }
                        self.tweets = safeTweets
                        self.tableView.reloadData()
                    })
                }else{
                    self.showMessage((error?.localizedDescription)!)
                }

            })
            break
        default:
            break
        }
    }
    
    
    fileprivate var isDataLoading: Bool = false
    
    // MARK: - View LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.topItem?.title = "PregBuddy Tweets"
        segmentControl.selectedSegmentIndex = 0
    }

    
    // MARK: - Selector Methods
    
    @objc func bookmarkAction(button : UIButton , withEvent event : UIEvent) -> () {
        
        let point = event.touches(for: button)?.first?.location(in: self.tableView)
        let indexPath : IndexPath = self.tableView.indexPathForRow(at: point!)!
        let tweet = tweets[indexPath.row]
        CoreDataWrapper.shared().bookmarkTweet(tweet)
        self.showMessage("Tweet bookmarked successfully!")

    }
}

extension HomeViewController: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (tableView.contentOffset.y) + (tableView.frame.size.height) >= tableView.contentSize.height{
            if !isDataLoading{
                tableView.tableFooterView!.isHidden = false
                loader.startAnimating()
                isDataLoading = true
                self.fetchTweets()
            }
        }
    }

}


extension HomeViewController{
    
    // MARK: - Private Methods

    fileprivate func fetchTweets(){
        
       
        TwitterWrapper.shared().loadTweets { (tweets, error) in
            
            self.tableView.tableFooterView!.isHidden = true
            self.loader.stopAnimating()
            if error == nil{
                DispatchQueue.main.async(execute: {
                    guard let safeTweet = tweets else {
                        return
                    }
                    for tweet in safeTweet{
                        self.tweets.append(tweet)
                    }
                    self.tableView.reloadData()
                })
            }else{
                self.showMessage((error?.localizedDescription)!)
            }
        }
    }
    
    fileprivate func setupLayout(){
        
        addUserInterfaceElements()
        applyConstraints()
    }
    
    private func addUserInterfaceElements(){
      
        view.addSubview(segmentControlContainerView)
        segmentControlContainerView.addSubview(segmentControl)
        view.addSubview(tableView)
    }
    
    private func applyConstraints(){
        
        if #available(iOS 11.0, *) {
            
            [segmentControlContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             segmentControlContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             segmentControlContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
                ].forEach({ $0.isActive = true
                })
        }else{
            [segmentControlContainerView.topAnchor.constraint(equalTo: view.topAnchor),
             segmentControlContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             segmentControlContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ].forEach({ $0.isActive = true
                })
        }
        
        tableView.topAnchor.constraint(equalTo: segmentControlContainerView.bottomAnchor).isActive = true
        segmentControlContainerView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        segmentControl.topAnchor.constraint(equalTo: segmentControlContainerView.topAnchor, constant: 8).isActive = true
        segmentControl.leadingAnchor.constraint(equalTo: segmentControlContainerView.leadingAnchor, constant: 26).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: segmentControlContainerView.trailingAnchor, constant: -26).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: segmentControlContainerView.bottomAnchor, constant: -8).isActive = true
    }
}
