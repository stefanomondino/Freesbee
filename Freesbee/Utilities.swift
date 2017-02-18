//
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

// Unfortunately the extra type annotations are required, otherwise the compiler gives an incomprehensible error.
extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

extension Observable where Element : Collection {
    func structured() -> Observable<ModelStructure> {
        
        return self.map({ (element:Element) -> ModelStructure? in
            guard let array = element as? [ModelType] else {
                return nil
            }
            return ModelStructure(array)}).ignoreNil()
        
        //        return self.map({$0 as?[ModelType]}).ignoreNil().map{ModelStructure($0)}
    }
}
extension Reactive where Base: UICollectionReusableView {
    var prepareForReuse:Observable<()> {
        return self.methodInvoked(#selector(UICollectionReusableView.prepareForReuse)).map {_ in return ()}
    }
}
