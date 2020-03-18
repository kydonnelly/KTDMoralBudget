//
//  RootViewController.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/15/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class RootViewController : UIViewController {
    
    @IBAction func pressedStartButton() {
        guard let jsonPath = Bundle.main.path(forResource: "OaklandDepartments", ofType: "json") else {
            return
        }
        
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped),
              let jsonInfos = try? decoder.decode(Array<DepartmentInfo>.self, from: data) else {
            return
        }
        
        let budgetMapStoryboard = UIStoryboard(name: "BudgetMap", bundle: .main)
        guard let budgetMapVC = budgetMapStoryboard.instantiateInitialViewController() as? BudgetMapViewController else {
            return
        }
        
        budgetMapVC.setup(departments: jsonInfos)
        
        self.navigationController?.pushViewController(budgetMapVC, animated: true)
    }
    
}
