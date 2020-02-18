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
        DepartmentInfo(name: "Public Works", caption: "shovel", details: "Fix The Potholes"),
        DepartmentInfo(name: "Economic and Workforce Development", caption: "jobs", details: "Training and work programs"),
        DepartmentInfo(name: "Capital Improvement", caption: "buildings", details: "Makes things look nice around the city"),
        DepartmentInfo(name: "Debt Servicing", caption: "owed", details: "make sure the city doesn't default"),
        DepartmentInfo(name: "Housing and Community Development", caption: "homes", details: "help people stay housed"),
        DepartmentInfo(name: "Human Services", caption: "ppl power", details: "services the humans"),
        DepartmentInfo(name: "Library", caption: "books", details: "it's always a fun day at your local library"),
        DepartmentInfo(name: "Parks and Recreation", caption: "trees", details: "fun in the sun"),
        DepartmentInfo(name: "Government Operations", caption: "running", details: "keeps the government operating"),
        DepartmentInfo(name: "Planning and Building", caption: "jackhammer and nails", details: "in charge of planning and building buildings")])
        
        self.navigationController?.pushViewController(buildBudgetVC, animated: true)
    }
    
}
