//
//  ShowListViewController+tvos.swift
//  Freesbee
//
//  Created by Stefano Mondino on 19/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import UIKit
import ParallaxView
extension ShowListViewController {
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        
        
        guard let prev = context.previouslyFocusedIndexPath else {
            return
        }
        guard let next = context.nextFocusedIndexPath else {
            return
        }
        
        let prevCell = collectionView.cellForItem(at: prev)
        let nextCell = collectionView.cellForItem(at: next)
        
        prevCell?.clipsToBounds = true
        nextCell?.clipsToBounds = true
        
        coordinator.addCoordinatedAnimations({
            
                nextCell?.addParallaxMotionEffects()
                prevCell?.removeParallaxMotionEffects()
            
        }, completion: nil)

        print ("updated")
    }
}
