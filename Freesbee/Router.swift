//
//  Router.swift
//
//  Created by Stefano Mondino on 11/11/16.
//  Copyright © 2016 Stefano Mondino. All rights reserved.
//

import Foundation
import Boomerang
import UIKit

import MediaPlayer
import AVKit

@available(iOS 9.0, *)




internal extension UIViewController {
    func withNavigation() -> NavigationController {
        
        return NavigationController(rootViewController: self)
    }
}

internal extension ViewModelBindable where Self : UIViewController {
    func withViewModel(_ viewModel:ViewModelType) -> Self {
        //        self.title = viewModel.navigationTitle
        self.bindTo(viewModel:viewModel, afterLoad: true)
        return self
    }
}

struct Router : RouterType {
    
    public static func exit<Source>(_ source:Source) where Source: UIViewController{
        _ = source.navigationController?.popToRootViewController(animated: true)
    }
    
    public static func dismiss<Source>(_ source:Source) where Source: UIViewController{
        _ = source.dismiss(animated: true, completion: nil)
    }
    
    public static func start(_ delegate:AppDelegate) {
        
        delegate.window = UIWindow(frame: UIScreen.main.bounds)
        delegate.window?.rootViewController = self.root()
        
        delegate.window?.makeKeyAndVisible()
        
    }
    
    public static func confirm<Source:UIViewController>(title:String,message:String,confirmationTitle:String, from source:Source, action:@escaping ((Void)->())) -> RouterAction {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmationTitle, style: .default, handler: {_ in action()}))
        return UIViewControllerRouterAction.modal(source: source, destination: alert, completion: nil)
    }
    
    public static func from<Source> (_ source:Source, viewModel:ViewModelType) -> RouterAction where Source: UIViewController {
        switch viewModel {
//    
        case is ShowDetailViewModel:
            let destination = (Storyboard.main.scene(.showDetail) as ShowDetailViewController).withViewModel(viewModel)
            _ = destination.view
            return UIViewControllerRouterAction.push(source: source, destination: destination)
        default:
            return EmptyRouterAction()
        }
    }
    
    //    public static func error<Source:UIViewController>(_ error:ErrorName, from source:Source) -> RouterAction {
    //
    //
    //        let viewModel = AlertWifiViewModel(error)
    //
    //        let destination = (Storyboard.alert.scene(.alertWifi) as AlertWifiViewController)
    //            .withViewModel(viewModel)
    //        return PopupRouterAction.modal(source: source, destination: destination, completion: nil)
    //    }
    
    
    public static func root() -> UIViewController {
                let source:ShowListViewController = Storyboard.main.scene(.showList)
        source.bindTo(viewModel:ViewModelFactory.showList(), afterLoad:true)
        return source.withNavigation()
        //
        
        //let source:VerticalRevolutionViewController = Storyboard.main.scene(.verticalRevolution)
        //source.bind(ViewModelFactory.verticalRevolution(), afterLoad:true)
        
        
        
        
    }
    
    public static func rootController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    public static func restart() {
        UIApplication.shared.keyWindow?.rootViewController = Router.root()
    }
    //    public static func gallery(withPhotos photos:[IDMPhotoProtocol], fromView view:UIImageView, startingFrom index:UInt = 0, withImage image:UIImage?) {
    //        let browser = IDMPhotoBrowser(photos: photos, animatedFrom: view)!
    //
    //        browser.scaleImage = image
    //        browser.displayActionButton = false;
    //        browser.displayArrowButton = false;
    //        browser.displayCounterLabel = false;
    //        browser.displayDoneButton = true;
    //        browser.usePopAnimation = true;
    //        browser.setInitialPageIndex(index)
    //        UIApplication.shared.keyWindow?.rootViewController?.present(browser, animated: true, completion: { /*browser.reloadData()*/})
    //    }
    public static func openApp<Source> (_ url:URL?, from source:Source) -> RouterAction
        where Source: UIViewController{
            if (url == nil) {return EmptyRouterAction()}
            
            return UIViewControllerRouterAction.custom(action: {
                UIApplication.shared.openURL(url!)
            })
            
    }
    
    public static func playVideo<Source> (_ url:URL?, from source:Source) -> RouterAction
        where Source: UIViewController{
            guard let urlFormatted:URL = URL(string:url?.absoluteString.removingPercentEncoding ?? "") else {
                return EmptyRouterAction()
            }
            
            //                   TEST video privato
            //                    let url:URL = URL(string: "https://sharepoint.eptarefrigeration.com/cms/Video%20Gallery/Epta_Logo_Origin_HD.mp4")!
            //                    var urlReq:URLRequest = URLRequest(url: url!)
            //
            //                    urlReq.addValue(APIManager.basicToken, forHTTPHeaderField: "Authorization")
            let playerController = AVPlayerViewController()
            let asset:AVURLAsset = AVURLAsset(url: urlFormatted, options: [:])
            
            //                    self.navigationController?.present(playerController, animated: true, completion: nil)
            
            return UIViewControllerRouterAction.modal(source: source, destination: playerController, completion: {
                let playerItem:AVPlayerItem =  AVPlayerItem(asset: asset)
                playerController.player = AVPlayer(playerItem: playerItem)
                playerController.player?.play()
            })
    }
}
