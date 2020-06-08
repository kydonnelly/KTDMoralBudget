//
//  MoralBudget+Attributions.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 6/8/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation

extension MoralBudget {
    
    public var attribution: String? {
        switch self {
        case .policeman: return "https://www.flaticon.com/authors/eucalyp"
        case .park: return "https://www.flaticon.com/authors/freepik"
        case .infrastructure: return "https://www.flaticon.com/authors/freepik"
        default: return nil
        }
    }
    
}
