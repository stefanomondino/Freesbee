//
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action
import Boomerang
import UIKit
import pop
import MBProgressHUD
import Localize_Swift
import AVKit



enum SharedSelectionOutput : SelectionOutput {
    case exit
    case dismiss
    case restart
    case url(URL?)
    case playVideo(URL?)
    case confirm(title:String,message:String,confirmTitle:String,action:((Void)->()))
//    case gallery(photos:[IDMPhotoProtocol],view:UIView, index:UInt, image:UIImage?)
}



class NavigationController : UINavigationController, UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        self.heroNavigationAnimationType =  .fade
    }
    

}

extension UIView {
    func findFirstResponder() -> UIView? {
        if (self.isFirstResponder) {
            return self
        }
        if (self.subviews.count == 0) {
            return nil
        }
        return self.subviews.map {$0.findFirstResponder() ?? self}.filter {$0 != self}.first
    }
}

protocol KeyboardResizable  {
    var bottomConstraint:NSLayoutConstraint! {get set}
    var scrollView:UIScrollView {get}
    var keyboardResize: Observable<CGFloat> {get}
}


protocol Collectionable {
    weak var collectionView:UICollectionView! {get}
    func setupCollectionView()
}
extension Collectionable where Self : UIViewController {
    func setupCollectionView() {
        self.collectionView.backgroundColor = .clear
    }
}

extension UIViewController {
    
    private struct AssociatedKeys {
        static var loaderCount = "loaderCount"
        static var DisposeBag = "vc_disposeBag"
    }
    
    internal var disposeBag: DisposeBag {
        var disposeBag: DisposeBag
        
        if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
            disposeBag = lookup
        } else {
            disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return disposeBag
    }

    
    func setup() -> UIViewController {
        let closure = {
//        var test = self.view.subviews.filter{$0 is UICollectionView}
        (self as? Collectionable)?.setupCollectionView()

        if ((self.navigationController?.viewControllers.count ?? 0) > 1) {
            _ = self.withBackButton()
        }
       
        }
        self.automaticallyAdjustsScrollViewInsets = false
        if (self.isViewLoaded) {
            closure()
        }
        else {
          _ = self.rx.methodInvoked(#selector(viewDidLoad)).delay(0.0, scheduler: MainScheduler.instance).subscribe(onNext:{_ in closure()})
        }
        
        return self
    }
    
    
    func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func withBackButton() -> UIViewController {
        let item = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = item
        return self
    }
    private var loaderCount:Int {
        
        get { return objc_getAssociatedObject(self, &AssociatedKeys.loaderCount) as? Int ?? 0}
        set { objc_setAssociatedObject(self, &AssociatedKeys.loaderCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
        
    }
    func loaderView() -> UIView {
        return UIActivityIndicatorView(activityIndicatorStyle: .white)
        //return RTSpinKitView(style: .stylePulse, color: UIColor.red, spinnerSize: 44)
    }
    func loaderContentView() -> UIView {
        return self.navigationController?.view ?? self.view
    }

    
    
    func showLoader() {
        
        if (self.loaderCount == 0) {
            DispatchQueue.main.async {[unowned self] in
                let hud = MBProgressHUD.showAdded(to: self.loaderContentView(), animated: true)
                let spin = self.loaderView()
                hud.customView = spin
                hud.mode = .customView
                hud.bezelView.color = .white
                hud.tintColor = .red
                hud.contentColor = .red
            }
            
        }
        self.loaderCount += 1
        
    }
    func hideLoader() {
        
        
        DispatchQueue.main.async {[weak self]  in
            if (self == nil) {
                return
            }
            self!.loaderCount = max(0, (self!.loaderCount ) - 1)
            if (self!.loaderCount == 0) {
                MBProgressHUD.hide(for: self!.loaderContentView(), animated: true)
            }
        }
        
    }
    func sharedSelection(_ output:SelectionOutput) {
        guard let shared = output as? SharedSelectionOutput else {
            return
        }
        switch shared {
        case .restart:
            Router.restart()
        case .url(let url) :
            Router.open(url, from: self).execute()
        case .exit:
            Router.exit(self)
        case .dismiss:
            Router.dismiss(self)
        case .confirm(let title, let message, let confirmTitle, let action) :
            Router.confirm(title: title, message: message, confirmationTitle: confirmTitle, from: self, action: action).execute()
            
        case .playVideo(let url):
            Router.playVideo(url, from: self).execute()

            
        }
    }
    func showError(_ error:ActionError) {
//        Router.error(error.unwrap(), from: self).execute()
    }
    
}



