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
            self.isHeroEnabled = true
        
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowListViewModel else {
            return
        }
        
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: 1)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selection.execute(.item(indexPath))
    }
}
