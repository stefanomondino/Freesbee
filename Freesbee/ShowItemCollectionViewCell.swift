//
//  ShowItemCollectionViewCell.swift
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
class ShowItemCollectionViewCell: UICollectionViewCell , ViewModelBindable {
    var viewModel: ViewModelType?
    let disposeBag = DisposeBag()
    @IBOutlet weak var lbl_title: UILabel?
    @IBOutlet weak var img_show: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(white: 0.98, alpha: 1)
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
