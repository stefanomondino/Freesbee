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
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_show: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowItemViewModel else {
            return
        }
        self.heroID = viewModel.heroID
        self.heroModifiers = [.arc]
        self.viewModel = viewModel
        self.lbl_title.text = viewModel.title
        if (self.isPlaceholder == false) {
            viewModel.image.takeUntil(self.rx.prepareForReuse).bindTo(self.img_show.rx.image).addDisposableTo(self.disposeBag)
        }
    }

}
