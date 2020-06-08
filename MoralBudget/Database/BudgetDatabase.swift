//
//  BudgetDatabase.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 6/6/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import Foundation
import SQLite3

class BudgetDatabase {
    
    public static let shared = BudgetDatabase()
    
    private let database: OpaquePointer
    
    private var cities: [Int32: City]? = nil
    private var budgetGroups: [Int32: BudgetGroup]? = nil
    private var budgetItems: [Int32: [BudgetItem]]? = nil
    
    init() {
        let dbPath = Bundle.main.path(forResource: "moral_budget", ofType: "db")
        
        var db: OpaquePointer?
        guard sqlite3_open(dbPath, &db) == SQLITE_OK, let openedDb = db else {
          preconditionFailure("Could not open local database!")
        }
        
        self.database = openedDb
    }
    
}

extension BudgetDatabase {
    
    public func allCities() -> [City] {
        return [City](self.loadedCities.values)
    }
    
    public func budgetGroup(type: BudgetGroupType, city: City) -> BudgetGroup? {
        return self.loadedBudgetGroups.values.first { $0.type == type && $0.city.id == city.id }
    }
    
    public func budgetItems(city: City) -> [BudgetItem]? {
        guard let group = self.budgetGroup(type: .city, city: city) else {
            return nil
        }
        
        return self.loadedBudgetItems[group.id]
    }
    
}

extension BudgetDatabase {
    
    fileprivate var loadedCities: [Int32: City] {
        if let cities = self.cities {
            return cities
        }
        
        let query = "SELECT id, name FROM cities;"
        var connection: OpaquePointer?
        guard sqlite3_prepare_v3(self.database, query, -1, 0, &connection, nil) == SQLITE_OK else {
            preconditionFailure("Could not select cities from database")
        }
        defer {
            sqlite3_finalize(connection)
        }
        
        var cities: [Int32: City] = [:]
        while (sqlite3_step(connection) == SQLITE_ROW) {
            let id = sqlite3_column_int(connection, 0)
            guard let name = sqlite3_column_text(connection, 1) else {
                let nameError = sqlite3_errcode(connection)
                preconditionFailure("Database memory error for city name with code \(nameError)")
            }
            
            let city = City(id: id, name: String(cString: name))
            cities[id] = city
        }
        
        self.cities = cities
        return cities
    }
    
    fileprivate var loadedBudgetGroups: [Int32: BudgetGroup] {
        if let groups = self.budgetGroups {
            return groups
        }
        
        let cities = self.loadedCities
        
        let query = "SELECT id, parent_id, city_id, group_type, description FROM budget_group;"
        var connection: OpaquePointer?
        guard sqlite3_prepare_v3(self.database, query, -1, 0, &connection, nil) == SQLITE_OK else {
            preconditionFailure("Could not select budget groups from database")
        }
        defer {
            sqlite3_finalize(connection)
        }
        
        var groups: [Int32: BudgetGroup] = [:]
        while (sqlite3_step(connection) == SQLITE_ROW) {
            let id = sqlite3_column_int(connection, 0)
            let parentId = sqlite3_column_int(connection, 1)
            let cityId = sqlite3_column_int(connection, 2)
            let type = sqlite3_column_int(connection, 3)
            guard let description = sqlite3_column_text(connection, 4) else {
                let descriptionError = sqlite3_errcode(connection)
                preconditionFailure("Database memory error for budget group description with code \(descriptionError)")
            }
            
            guard let city = cities[cityId] else {
                preconditionFailure("All budget groups are expected to belong to a city")
            }
            
            let groupType = BudgetGroupType(rawValue: type) ?? .unknown
            let group = BudgetGroup(id: id, parentId: parentId, city: city, type: groupType, description: String(cString: description))
            groups[id] = group
        }
        
        self.budgetGroups = groups
        return groups
    }
    
    fileprivate var loadedBudgetItems: [Int32: [BudgetItem]] {
        if let infos = self.budgetItems {
            return infos
        }
        
        let budgetGroups = self.loadedBudgetGroups
        
        let query = "SELECT id, group_id, category, title, percentage, amount, description FROM budget_item;"
        var connection: OpaquePointer?
        guard sqlite3_prepare_v3(self.database, query, -1, 0, &connection, nil) == SQLITE_OK else {
            preconditionFailure("Could not select cities from database")
        }
        defer {
            sqlite3_finalize(connection)
        }
        
        var items: [Int32: [BudgetItem]] = [:]
        while (sqlite3_step(connection) == SQLITE_ROW) {
            let id = sqlite3_column_int(connection, 0)
            let groupId = sqlite3_column_int(connection, 1)
            let categoryId = sqlite3_column_int(connection, 2)
            guard let title = sqlite3_column_text(connection, 3) else {
                let titleError = sqlite3_errcode(connection)
                preconditionFailure("Database memory error for budget item title with code \(titleError)")
            }
            let percentage = sqlite3_column_double(connection, 4)
            let amount = sqlite3_column_double(connection, 5)
            let cDescription = sqlite3_column_text(connection, 6)
            
            guard let group = budgetGroups[groupId] else {
                preconditionFailure("All budget items are expected to belong to a group.")
            }
            
            let category = BudgetCategory(rawValue: categoryId) ?? .uncategorized
            let description = cDescription == nil ? "" : String(cString: cDescription!)
            let item = BudgetItem(id: id, group: group, category: category, title: String(cString: title), percentage: percentage, amount: amount, description: description)
            
            var groupItems: [BudgetItem] = items[groupId] ?? []
            groupItems.append(item)
            items[groupId] = groupItems
        }
        
        self.budgetItems = items
        return items
    }
    
}
