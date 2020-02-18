//
//  RootViewController.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/15/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class RootViewController : UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let buildBudgetStoryboard = UIStoryboard(name: "BuildBudget", bundle: .main)
        guard let buildBudgetVC = buildBudgetStoryboard.instantiateInitialViewController() as? BuildBudgetViewController else {
            return
        }
        
        buildBudgetVC.setup(departments: [DepartmentInfo(name: "Police", caption: "FTP", details: "FTP, ACAB"),
        DepartmentInfo(name: "Fire", caption: "smokey", details: "Puts out fires and saves kittens"),
        DepartmentInfo(name: "Public Works", caption: "shovel", details: "Fix The Potholes")])
        
        self.navigationController?.pushViewController(buildBudgetVC, animated: true)
    }
    
}
