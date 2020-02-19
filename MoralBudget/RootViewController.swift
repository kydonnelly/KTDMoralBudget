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
        let buildBudgetStoryboard = UIStoryboard(name: "BuildBudget", bundle: .main)
        guard let buildBudgetVC = buildBudgetStoryboard.instantiateInitialViewController() as? BuildBudgetViewController else {
            return
        }
        
        guard let jsonPath = Bundle.main.path(forResource: "OaklandDepartments", ofType: "json") else {
            return
        }
        
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped),
              let jsonInfos = try? decoder.decode(Array<DepartmentInfo>.self, from: data) else {
            return
        }
        
        buildBudgetVC.setup(departments: jsonInfos)
        
        self.navigationController?.pushViewController(buildBudgetVC, animated: true)
    }
    
}
