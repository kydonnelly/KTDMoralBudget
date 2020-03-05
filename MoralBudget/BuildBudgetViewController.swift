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
    
    var shouldNormalize: Bool = false
    var shouldAutoSort: Bool = false
    
    // parallel arrays
    private var departments: [DepartmentInfo] = []
    private var allocations: [Double] = []
    private var locks: [Bool] = []
    
    func setup(departments: [DepartmentInfo]) {
        self.departments = departments
        self.allocations = Array(repeating: (1.0 / Double(departments.count)), count: departments.count)
        self.locks = Array(repeating: false, count: departments.count)
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
        let isLocked = self.locks[indexPath.row]
        
        cell.setup(title: department.name, subtitle: department.caption, initialValue: allocation, isLocked: isLocked, updateBlock: { [weak self] (value) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.allocations[indexPath.row] = value
            strongSelf.refreshPercentageLabel()
            
            if strongSelf.shouldNormalize {
                strongSelf.normalizePercentages()
                strongSelf.refreshData()
            }
            }, lockBlock: { [weak self] (isLocked) in
                guard let self = self else {
                    return false
                }
                
                if isLocked {
                    let current = self.currentLockedPercentage()
                    let attempt = self.allocations[indexPath.row]
                    
                    guard current + attempt <= 1.0 else {
                        let alert = UIAlertController(title: "Cannot lock \(department.name)", message: "You already have \(round(current * 1000) / 10.0)% locked. Locking another \(round(attempt * 1000) / 10.0)% would exceed 100% which is not supported.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { [weak self] (action) in
                            self?.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return false
                    }
                }

                self.locks[indexPath.row] = isLocked
                
                return true
            }, touchUpBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if strongSelf.shouldAutoSort {
                strongSelf.sortDepartmentsByAllocation()
            }
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
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
}

extension BuildBudgetViewController {
    
    fileprivate func currentTotalPercentage() -> Double {
        return self.allocations.reduce(0, +)
    }
    
    fileprivate func currentLockedPercentage() -> Double {
        return self.allocations.enumerated().reduce(0.0) { (sum, iter) -> Double in
            if self.locks[iter.offset] {
                return sum + iter.element
            } else {
                return sum
            }
        }
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
    
    @IBAction func tappedLockSwitch(_ lockSwitch: UISwitch) {
        self.shouldNormalize = lockSwitch.isOn
        
        if self.shouldNormalize {
            self.normalizePercentages()
            self.refreshData()
        }
    }
    
    fileprivate func normalizePercentages() {
        let totalPercentage = self.currentTotalPercentage()
        let lockedPercentage = min(1.0, self.currentLockedPercentage())
        let unlockedPercentage = totalPercentage - lockedPercentage
        
        var ratio = 0.0
        if unlockedPercentage != 0 {
            ratio = (1.0 - lockedPercentage) / unlockedPercentage
        }
        
        for (index, percentage) in self.allocations.enumerated() {
            if !self.locks[index] {
                self.allocations[index] = percentage * ratio
            }
        }
    }
    
}

extension BuildBudgetViewController {
    
    @IBAction func tappedAutoSort(_ sortSwitch: UISwitch) {
        self.shouldAutoSort = sortSwitch.isOn
        
        if self.shouldAutoSort {
            self.sortDepartmentsByAllocation()
        }
    }
    
    private func sortDepartmentsByAllocation() {
        let sortedAllocations = self.allocations.enumerated().sorted { $0.element > $1.element }
        let departmentsCopy = self.departments
        
        self.allocations = sortedAllocations.map { $0.element }
        self.departments = sortedAllocations.map { departmentsCopy[$0.offset] }
        
        self.tableView.performBatchUpdates({
            for (newIndex, oldInfo) in sortedAllocations.enumerated() {
                self.tableView.moveRow(at: IndexPath(row: oldInfo.offset, section: 0),
                                       to: IndexPath(row: newIndex, section: 0))
            }
        }, completion: { [weak self] (_) in
            // Do this after animations have completed.
            // Reloads the department info inside the cells
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        })
    }
    
}

extension BuildBudgetViewController {
    
    @IBAction func tappedNextButton() {
        if abs(self.currentTotalPercentage() - 1.0) < 0.01 {
            self.showResultsScreen()
        } else {
            let alert = UIAlertController(title: "Addition error!", message: "Your budget doesn't add up to 100%. Would you like to auto-adjust and continue to results?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "continue", style: .default, handler: { [weak self] _ in
                self?.showResultsScreen()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showResultsScreen() {
        self.normalizePercentages()
        
        let brsb = UIStoryboard(name: "BudgetResults", bundle: .main)
        guard let brvc = brsb.instantiateInitialViewController() as? BudgetResultsViewController else {
            preconditionFailure("unexpected storyboard setup")
        }
        
        brvc.setup(departments: self.departments, allocations: self.allocations)
        self.navigationController?.pushViewController(brvc, animated: true)
    }
    
}
