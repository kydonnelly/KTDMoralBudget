//
//  BuildBudgetViewController.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/15/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class BuildBudgetViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalPercentLabel: UILabel!
    
    @IBOutlet var headerView: UIView!
    
    // parallel arrays
    private var departments: [DepartmentInfo] = []
    private var allocations: [Double] = []
    
    func setup(departments: [DepartmentInfo]) {
        self.departments = departments
        self.allocations = Array(repeating: (1.0 / Double(departments.count)), count: departments.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    private func refreshData() {
        self.tableView.reloadData()
        self.refreshPercentageLabel()
    }
    
}

extension BuildBudgetViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell", for: indexPath) as? DepartmentSliderCell else {
            preconditionFailure("Missing expected table cell type!")
        }
        
        let department = self.departments[indexPath.row]
        let allocation = self.allocations[indexPath.row]
        cell.setup(title: department.name, subtitle: department.caption, initialValue: allocation, updateBlock: { [weak self] (value) in
            self?.allocations[indexPath.row] = value
            self?.refreshPercentageLabel()
        })
        
        return cell
    }
    
}

extension BuildBudgetViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let department = self.departments[indexPath.row]
        let alert = UIAlertController(title: "\(department.name) details", message: department.details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
}

extension BuildBudgetViewController {
    
    fileprivate func currentTotalPercentage() -> Double {
        return self.allocations.reduce(0, +)
    }
    
    private func refreshPercentageLabel() {
        let totalPercentage = self.currentTotalPercentage()
        let visiblePercentage = round(totalPercentage * 1000.0) / 10.0
        self.totalPercentLabel.text = "Total: \(visiblePercentage)%"
        
        // scale from green at 100% to red at 50%
        self.totalPercentLabel.textColor = UIColor(red: CGFloat(abs(visiblePercentage - 100.0)) * 0.02,
                                                   green: 1.0 - CGFloat(abs(visiblePercentage - 100.0)) * 0.02,
                                                   blue: 0.2, alpha: 1)
    }
    
    @IBAction func tappedPercentageButton() {
        self.normalizePercentages()
        
        self.refreshData()
    }
    
    fileprivate func normalizePercentages() {
        let totalPercentage = self.currentTotalPercentage()
        guard totalPercentage > 0 else {
            return
        }
        
        let ratio = 1.0 / totalPercentage
        
        for (index, percentage) in self.allocations.enumerated() {
            self.allocations[index] = percentage * ratio
        }
    }
    
}

extension BuildBudgetViewController {
    
    @IBAction func tappedNextButton() {
        self.normalizePercentages()
        
        var departmentAllocations: [DepartmentAllocation] = []
        
        for (index, info) in self.departments.enumerated() {
            departmentAllocations.append(DepartmentAllocation(info: info, percentage: self.allocations[index]))
        }
        
        let brsb = UIStoryboard(name: "BudgetResults", bundle: .main)
        guard let brvc = brsb.instantiateInitialViewController() as? BudgetResultsViewController else {
            preconditionFailure("unexpected storyboard setup")
        }
        
        brvc.setup(allocations: departmentAllocations)
        self.navigationController?.pushViewController(brvc, animated: true)
    }
    
}
