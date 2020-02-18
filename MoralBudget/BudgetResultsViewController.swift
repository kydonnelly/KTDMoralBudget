//
//  BudgetResultsViewController.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/17/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class BudgetResultsViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // parallel arrays?
    private var myAllocations: [DepartmentAllocation] = []
    private var cityAllocations: [DepartmentAllocation] = []
    
    func setup(allocations: [DepartmentAllocation]) {
        self.myAllocations = allocations
        self.cityAllocations = [DepartmentAllocation(info: DepartmentInfo(name: "Police", caption: "FTP", details: "FTP, ACAB"), percentage: 0.206),
                                DepartmentAllocation(info: DepartmentInfo(name: "Fire", caption: "smokey", details: "Puts out fires and saves kittens"), percentage: 0.104),
                                DepartmentAllocation(info: DepartmentInfo(name: "Public Works", caption: "shovel", details: "Fix The Potholes"), percentage: 0.102),
                                DepartmentAllocation(info: DepartmentInfo(name: "Economic and Workforce Development", caption: "jobs", details: "Training and work programs"), percentage: 0.02),
                                DepartmentAllocation(info: DepartmentInfo(name: "Capital Improvement", caption: "buildings", details: "Makes things look nice around the city"), percentage: 0.04),
                                DepartmentAllocation(info: DepartmentInfo(name: "Debt Servicing", caption: "owed", details: "make sure the city doesn't default"), percentage: 0.246),
                                DepartmentAllocation(info: DepartmentInfo(name: "Housing and Community Development", caption: "homes", details: "help people stay housed"), percentage: 0.013),
                                DepartmentAllocation(info: DepartmentInfo(name: "Human Services", caption: "ppl power", details: "services the humans"), percentage: 0.060),
                                DepartmentAllocation(info: DepartmentInfo(name: "Library", caption: "books", details: "it's always a fun day at your local library"), percentage: 0.024),
                                DepartmentAllocation(info: DepartmentInfo(name: "Parks and Recreation", caption: "trees", details: "fun in the sun"), percentage: 0.022),
                                DepartmentAllocation(info: DepartmentInfo(name: "Government Operations", caption: "smoothly", details: "help the government operate"), percentage: 0.137),
                                DepartmentAllocation(info: DepartmentInfo(name: "Planning and Building", caption: "jackhammer and nails", details: "in charge of planning and building buildings"), percentage: 0.026)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
}

extension BudgetResultsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityAllocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllocationCell", for: indexPath) as? DepartmentAllocationCell else {
            preconditionFailure("Missing expected table cell type!")
        }
        
        let myAllocation = self.myAllocations[indexPath.row]
        let cityAllocation = self.cityAllocations[indexPath.row]
        cell.setup(departmentInfo: cityAllocation.info, myAllocation: myAllocation.percentage, cityAllocation: cityAllocation.percentage)
        
        return cell
    }
    
}

extension BudgetResultsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let department = self.cityAllocations[indexPath.row].info
        let alert = UIAlertController(title: "\(department.name) details", message: department.details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
