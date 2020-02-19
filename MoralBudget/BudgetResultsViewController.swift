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
    private var departments: [DepartmentInfo] = []
    private var myAllocations: [Double] = []
    
    func setup(departments: [DepartmentInfo], allocations: [Double]) {
        self.myAllocations = allocations
        self.departments = departments
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
        return self.departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllocationCell", for: indexPath) as? DepartmentAllocationCell else {
            preconditionFailure("Missing expected table cell type!")
        }
        
        let myAllocation = self.myAllocations[indexPath.row]
        let department = self.departments[indexPath.row]
        cell.setup(departmentInfo: department, myAllocation: myAllocation, cityAllocation: department.allocation)
        
        return cell
    }
    
}

extension BudgetResultsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let department = self.departments[indexPath.row]
        let alert = UIAlertController(title: "\(department.name) details", message: department.details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
