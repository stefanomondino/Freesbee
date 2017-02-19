//
//  ViewController+iOS.swift
//  Freesbee
//
//  Created by Stefano Mondino on 19/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
extension NavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
        
    }
    override var shouldAutorotate: Bool{
        return true;
    }
}

extension KeyboardResizable where Self : UIViewController {
    //    var keyboardResize: Observable<CGFloat> {return .just(0)}
    var keyboardResize: Observable<CGFloat>  {
        self.scrollView.keyboardDismissMode = .onDrag
        let original:CGFloat = self.bottomConstraint.constant
        var currentBottomSpace:CGFloat = 0.0
        let willShow = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow)
        let willHide = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide)
        let merged = Observable.of(willShow,willHide).merge()
        
        let vc = self as UIViewController
        return
            merged
                .takeUntil(vc.rx.deallocating)
                .throttle(0.1, scheduler:MainScheduler.instance)
                .scan(self.bottomConstraint.constant, accumulator: {[weak self] (value:CGFloat, notification:Notification) -> CGFloat in
                    if (self == nil) {
                        return 0
                    }
                    let isShowing = notification.name == .UIKeyboardWillShow
                    currentBottomSpace = isShowing ? self!.finalConstraintValueValueForKeyboardOpen(frame: (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect(x:0,y:0,width:0,height:0) ) : original
                    
                    
                    let duration:Double = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
                    
                    
                    let animation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)!
                    animation.duration = duration
                    animation.toValue = currentBottomSpace
                    animation.completionBlock = {
                        animation, completed in
                        
                        if (completed) {
                            let view = self?.scrollView.findFirstResponder()
                            if (view != nil) {
                                var frame = view!.convert(view!.frame, to: self!.scrollView)
                                frame.origin.y += 20
                                self?.scrollView.scrollRectToVisible(frame, animated: true)
                            }
                        }
                        //                                if (self!.scrollView.delegate?.responds(to: #selector(UIScrollViewDelegate.scrollViewDidScroll(_:))) == true) {
                        //                                    self!.scrollView.delegate!.scrollViewDidScroll!(self!.scrollView)
                        //                                }
                        
                    }
                    self!.bottomConstraint.pop_add(animation, forKey: "constraint")
                    return currentBottomSpace
                })
        
    }
    func finalConstraintValueValueForKeyboardOpen(frame:CGRect) -> CGFloat {
        return frame.size.height
    }
}
