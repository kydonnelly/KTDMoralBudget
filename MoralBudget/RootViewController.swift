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
        
        buildBudgetVC.setup(departments: [DepartmentInfo(name: "Police", caption: "FTP", details: "FTP, ACAB"),
        DepartmentInfo(name: "Fire", caption: "smokey", details: "Puts out fires and saves kittens"),
        DepartmentInfo(name: "Public Works", caption: "shovel", details: "Fix The Potholes"),
        DepartmentInfo(name: "Jobs", caption: "Economic & Workforce Development", details: "Training and work programs"),
        DepartmentInfo(name: "Infrastructure", caption: "Capital Improvement", details: "Makes things look nice around the city"),
        DepartmentInfo(name: "Debt Payments", caption: "Debt Services", details: "make sure the city doesn't default"),
        DepartmentInfo(name: "Housing", caption: "Housing & Community Development", details: "help people stay housed"),
        DepartmentInfo(name: "Services", caption: "Human & Community Services", details: "services the humans"),
        DepartmentInfo(name: "Libraries", caption: "books", details: "it's always a fun day at your local library"),
        DepartmentInfo(name: "Parks & Rec", caption: "trees", details: "fun in the sun"),
        DepartmentInfo(name: "Administrative", caption: "Government Operations", details: "keeps the government operating"),
        DepartmentInfo(name: "Planning", caption: "Planning and Building", details: "in charge of planning and building buildings")])
        
        self.navigationController?.pushViewController(buildBudgetVC, animated: true)
    }
    
}
