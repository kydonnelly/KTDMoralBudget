//
//  BudgetDatabase.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 6/6/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation

class BudgetDatabase {
    
    public static let shared = BudgetDatabase()
    
    private let cities: [String]
    private let departmentInfos: [String: [DepartmentInfo]]
    
    init() {
        guard let jsonPath = Bundle.main.path(forResource: "Departments", ofType: "json") else {
            preconditionFailure("Could not load json file")
        }
        
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped),
              let jsonInfos = try? decoder.decode(Dictionary<String, Array<DepartmentInfo>>.self, from: data) else {
            preconditionFailure("Could not decode json file contents")
        }
        
        self.cities = jsonInfos.keys.sorted()
        self.departmentInfos = jsonInfos
    }
    
    public var allCities: [String] {
        return self.cities
    }
    
    public func departmentInfos(city: String) -> [DepartmentInfo] {
        return self.departmentInfos[city] ?? []
    }
    
}
