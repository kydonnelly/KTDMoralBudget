//
//  DepartmentInfo.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/15/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation

struct DepartmentInfo {
    let name: String
    let caption: String
    let details: String
    let allocation: Double
}

extension DepartmentInfo : Decodable { }
