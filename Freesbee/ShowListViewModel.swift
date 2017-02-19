//
//  ShowListViewModel.swift
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum ShowListInput : SelectionInput {
    case item(IndexPath)
}
enum ShowListOutput : SelectionOutput {
    case viewModel(ViewModelType)
}
final class ShowListViewModel : ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Show else {
            return nil
        }
        return ViewModelFactory.showItem(fromModel: item)
    }
    
    lazy var selection: Action<ShowListInput, ShowListOutput> = Action { input in
        switch input {
        case .item(let indexPath) :
            guard let show:Show = self.model(atIndex: indexPath) as? Show else {
                return .empty()
            }
            return .just(ShowListOutput.viewModel(ViewModelFactory.showDetail(fromModel:show)))
        }
    }
    init() {
        self.dataHolder = ListDataHolder(data: APIManager.shows().structured())
    }
}
