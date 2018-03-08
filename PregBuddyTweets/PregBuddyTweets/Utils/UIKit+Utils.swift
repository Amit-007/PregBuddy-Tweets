//
//  UIKit+Utils.swift
//  PregBuddyTweets
//
//  Created by Amit Majumdar on 07/03/18.
//  Copyright © 2018 Amit Majumdar. All rights reserved.
//

import UIKit

extension UIColor{
   
    static let twitter     = UIColor(netHex: 0x1DA1F2)
    
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    var imageRepresentation : UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIFont{
    
    class func helvitaOblique(_ size : CGFloat) ->UIFont {
        return UIFont(name: "Helvetica-Oblique", size: size)!
    }
    class func helvitaObliqueBold(_ size : CGFloat) ->UIFont {
        return UIFont(name: "Helvetica-BoldOblique", size: size)!
    }
    class func helvita(_ size : CGFloat) ->UIFont {
        return UIFont(name: "Helvetica", size: size)!
    }
    class func helvitaLight(_ size : CGFloat) ->UIFont {
        return UIFont(name: "Helvetica-Light", size: size)!
    }
    class func helvitaBold(_ size : CGFloat) ->UIFont {
        return UIFont(name: "Helvetica-Bold", size: size)!
    }
    class func helveticaLightOblique(_ size : CGFloat) ->UIFont {
        return UIFont(name: "Helvetica-LightOblique", size: size)!
    }
    
}

extension UIViewController{
    
    func showMessage(_ message : String) {
        
        let alertController = UIAlertController(title: "PregBuddy Tweets", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okay)
        self.present(alertController, animated: true, completion: nil)
    }
}

