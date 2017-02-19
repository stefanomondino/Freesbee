//
//  Router+tvOS.swift
//  Freesbee
//
//  Created by Stefano Mondino on 19/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang

extension Router {
    public static func open<Source> (_ url:URL?, from source:Source) -> RouterAction {
        return EmptyRouterAction()
    }
}
