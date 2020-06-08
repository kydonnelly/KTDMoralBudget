//
//  BudgetItem.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 6/7/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation

struct BudgetItem {
    let id: Int32
    let group: BudgetGroup
    let category: BudgetCategory
    let title: String
    let percentage: Double
    let amount: Double
    let description: String
}
