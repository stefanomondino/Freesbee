//
//  ShowDetailViewModel.swift
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ShowDetailViewModel : ListViewModelType , ItemViewModelType{
    var dataHolder: ListDataHolderType = ListDataHolder()
    var itemIdentifier: ListIdentifier = ""
    var model: ItemViewModelType.Model
    var title:String?
    func itemViewModel(_ model: ModelType) -> ItemViewModelType? {
        return model as? ItemViewModelType
    }
    
    init(model: Show) {
        self.title = model.title
     self.model = model
        let array:[ItemViewModelType] = [ViewModelFactory.showTitleItem(fromModel: model)]
        self.dataHolder = ListDataHolder(data: .just(ModelStructure(array)))
    }
}
