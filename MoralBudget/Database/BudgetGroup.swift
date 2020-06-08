//
//  BudgetGroup.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 6/7/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation

struct BudgetGroup {
    let id: Int32
    let parentId: Int32
    let city: City
    let type: BudgetGroupType
    let description: String
}
