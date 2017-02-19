//
//  Router+Safari.swift
//  Freesbee
//
//  Created by Stefano Mondino on 19/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import SafariServices

extension SFSafariViewController {
    class func canOpenURL(URL: URL) -> Bool {
        return URL.host != nil && (URL.scheme == "http" || URL.scheme == "https")
    }
}
extension Router {
    public static func open<Source> (_ url:URL?, from source:Source) -> RouterAction
        where Source: UIViewController{
            if (url == nil) {return EmptyRouterAction()}
            if (!SFSafariViewController.canOpenURL(URL:url!)) {
                return UIViewControllerRouterAction.custom(action: {
                    UIApplication.shared.openURL(url!)
                })
            }
            let vc = SFSafariViewController(url: url!, entersReaderIfAvailable: true)
            return UIViewControllerRouterAction.modal(source: source, destination: vc, completion: nil)
    }
}
