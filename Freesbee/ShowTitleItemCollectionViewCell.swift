//
//  ShowTitleItemCollectionViewCell.swift
//  Freesbee
//
//  Created by Stefano Mondino on 19/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import RxCocoa
class ShowTitleItemCollectionViewCell: UICollectionViewCell, ViewModelBindable {

    var viewModel: ViewModelType?
    let disposeBag = DisposeBag()
    @IBOutlet weak var lbl_title: UILabel?
    @IBOutlet weak var img_show: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowItemViewModel else {
            return
        }
        self.img_show.heroID = "img_"+viewModel.heroID
        self.lbl_title?.heroID = "title_"+viewModel.heroID
        self.img_show.heroModifiers = [.zPosition(100)]
        self.viewModel = viewModel
        self.lbl_title?.text = viewModel.title
        if (self.isPlaceholder == false) {
            viewModel.image.takeUntil(self.rx.prepareForReuse).bindTo(self.img_show.rx.image).addDisposableTo(self.disposeBag)
        }
    }

}
