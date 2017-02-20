//
//  ShowItemViewModel.swift
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ShowItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = Cell.showItem
    var title:String?
    var image:Observable<UIImage?>
    var heroID:String
    init(model:Show) {
        self.model = model
        self.title = model.title
        self.image = APIManager.downloadImage(model.imageURL)
        self.heroID = model.imageURL?.absoluteString ?? ""
    }
}
