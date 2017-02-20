//
//  ShowListViewController.swift
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang


class ShowListViewController : UIViewController, ViewModelBindable, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: ShowListViewModel?
    var flow:UICollectionViewFlowLayout? {
        return self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.remembersLastFocusedIndexPath = true
        self.automaticallyAdjustsScrollViewInsets = false
            self.isHeroEnabled = true
        
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowListViewModel else {
            return
        }
        self.title = viewModel.title
        self.viewModel = viewModel
        self.collectionView.bindTo(viewModel:viewModel)
        self.collectionView.delegate = self
        viewModel.selection.elements.subscribe(onNext :{[weak self] output in
            switch output {
            case .viewModel(let viewModel):
                Router.from(self!, viewModel: viewModel).execute()
            }
        }).addDisposableTo(self.disposeBag)
        viewModel.reload()
        let refresh = UIRefreshControl()
        refresh.rx.bindTo(action: viewModel.dataHolder.reloadAction, controlEvent: refresh.rx.controlEvent(.allEvents)) { (_) in
            return nil
        }
        viewModel.dataHolder.reloadAction.executing.bindTo(refresh.rx.isRefreshing).addDisposableTo(self.disposeBag)
        self.collectionView.addSubview(refresh)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let n = round(self.view.frame.size.width/160.0) //on iphoneSE (320px wide) , 2 columns.
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: Int(n))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selection.execute(.item(indexPath))
    }
    
    
}
