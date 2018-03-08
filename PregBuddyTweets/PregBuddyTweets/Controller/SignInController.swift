//
//  SignInController.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//


import UIKit
import TwitterKit

class SignInController: UIViewController {
    
    // MARK: - View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}


extension SignInController{
    
    fileprivate func setupLayout(){
      
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            if userID.count != 0 {
                moveToHome(false)
            }else{
                setupLoginLayout()
            }
        }else{
             setupLoginLayout()
        }
    }
    
    private func setupLoginLayout(){
       
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            
            if (session != nil) {
                self.moveToHome(true)
                print("signed in as \(String(describing: session?.userName))")
            } else {
                print("error: \(String(describing: error?.localizedDescription))")
                TWTRTwitter.sharedInstance().logIn(completion: { (loginsession, loginerror) in
                    if (session != nil) {
                        print("signed in as \(String(describing: loginsession?.userName))")
                        self.moveToHome(true)
                    } else {
                        print("error: \(String(describing: loginerror?.localizedDescription))")
                    }
                })
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    
    private func moveToHome(_ animated: Bool){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.navigationController?.pushViewController(appDelegate.tabBarController(), animated: animated)
        }
    }
    
    
}
