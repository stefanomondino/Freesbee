//
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action
import Boomerang



typealias Selection = Action<SelectionInput,SelectionOutput>

struct ViewModelFactory {
    static func showList() -> ViewModelType {
        return ShowListViewModel()
    }
    static func showItem(fromModel show:Show) -> ItemViewModelType {
        return ShowItemViewModel(model: show)
    }
    static func showTitleItem(fromModel show:Show) -> ItemViewModelType {
        let item = ShowItemViewModel(model: show)
        item.itemIdentifier = Cell.showTitleItem
        return item
    }
    static func showDetail(fromModel show:Show) -> ViewModelType {
        return ShowDetailViewModel(model: show)
    }
}
