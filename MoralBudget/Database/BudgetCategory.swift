//
//  BudgetCategory.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 6/7/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation

enum BudgetCategory: Int32 {
    case police = 0
    case fire = 1
    case services = 2
    case library = 3
    case parksAndRec = 4
    case housing = 5
    case transportation = 6
    case obligations = 7
    case infrastructure = 8
    case jobs = 9
    case publicWorks = 10
    case administration = 11
    case planning = 12
    case uncategorized = -1
}

extension BudgetCategory {
    
    public var iconName: String {
        switch self {
        case .police: return "policeman"
        case .fire: return "fire"
        case .services: return "social"
        case .library: return "books"
        case .parksAndRec: return "park"
        case .housing: return "housing"
        case .transportation: return "tramway"
        case .obligations: return "debt"
        case .infrastructure: return "infrastructure"
        case .jobs: return "work"
        case .publicWorks: return "publicworks"
        case .administration: return "legal"
        case .planning: return "planning"
        case .uncategorized: return "ellipsis"
        }
    }
    
    public var iconColorHex: UInt {
        switch self {
        case .police: return 0x5175A0
        case .fire: return 0xEF3E36
        case .services: return 0x6A7FDB
        case .library: return 0xA89959
        case .parksAndRec: return 0x4B8F4B
        case .housing: return 0xC5D1EB
        case .transportation: return 0xEDAE49
        case .obligations: return 0x7A6C5D
        case .infrastructure: return 0xEC4E20
        case .jobs: return 0x8BB174
        case .publicWorks: return 0xECA72C
        case .administration: return 0x4E8C85
        case .planning: return 0xAF8CE2
        case .uncategorized: return 0xFBF5F3
        }
    }
    
}
