//
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang

enum Storyboard : String {
    case main = "Main"
    func scene<Type:UIViewController>(_ identifier:SceneIdentifier) -> Type {
        return UIStoryboard(name: self.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier.rawValue).setup() as! Type
    }
}
enum SceneIdentifier : String {
    case showList = "showList"
    case showDetail = "showDetail"
}
extension ListViewModelType {
    var listIdentifiers: [ListIdentifier] {
        return Cell.all()
    }
}
enum Cell : String, ListIdentifier {
    case showItem = "ShowItemCollectionViewCell"
    case showTitleItem = "ShowTitleItemCollectionViewCell"
    static func all() -> [Cell] {
        return [
           .showItem,
           .showTitleItem
        ]
    }
    static func headers() -> [Cell] {
        return self.all().filter{ $0.type == UICollectionElementKindSectionHeader}
    }
    var name: String {return self.rawValue}
    var type: String? {
        switch self {
        
        default: return nil
            
        }
    }
}

enum View: String {
    case filtersView = "FiltersView"
    var loadView:UIView?  {
        return Bundle.main.loadNibNamed(self.rawValue, owner: nil, options: nil)?.first as? UIView
    }
    
}
extension Cell {
    func cell<T:UICollectionViewCell>() -> T {
        return UINib(nibName: self.rawValue, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
}

