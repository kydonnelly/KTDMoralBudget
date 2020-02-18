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
    
}

extension BuildBudgetViewController {
    
    private func refreshPercentageLabel() {
        let totalPercentage = self.allocations.reduce(0, +)
        let visiblePercentage = round(totalPercentage * 1000.0) / 10.0
        self.totalPercentLabel.text = "\(visiblePercentage)%"
        
        if visiblePercentage == 100.0 {
            self.totalPercentLabel.textColor = .green
        } else {
            self.totalPercentLabel.textColor = .red
        }
    }
    
    @IBAction func tappedPercentageButton() {
        let totalPercentage = self.allocations.reduce(0, +)
        guard totalPercentage > 0 else {
            return
        }
        
        let ratio = 1.0 / totalPercentage
        
        for (index, percentage) in self.allocations.enumerated() {
            self.allocations[index] = percentage * ratio
        }
        
        self.refreshData()
    }
    
}
