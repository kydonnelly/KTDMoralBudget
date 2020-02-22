//
//  BudgetResultsViewController.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/17/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class BudgetResultsViewController : UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    // parallel arrays?
    private var departments: [DepartmentInfo] = []
    private var myAllocations: [Double] = []
    
    func setup(departments: [DepartmentInfo], allocations: [Double]) {
        self.myAllocations = allocations
        self.departments = departments
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }
    
}

extension BudgetResultsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.departments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllocationCell", for: indexPath) as? DepartmentAllocationCell else {
            preconditionFailure("Missing expected cell type!")
        }
        
        let myAllocation = self.myAllocations[indexPath.row]
        let department = self.departments[indexPath.row]
        cell.setup(departmentInfo: department, myAllocation: myAllocation, cityAllocation: department.allocation)
        
        return cell
    }
    
}

extension BudgetResultsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let department = self.departments[indexPath.row]
        let alert = UIAlertController(title: "\(department.name) details", message: department.details, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension BudgetResultsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.bounds.size.width
        return CGSize(width: collectionViewSize * 0.5, height: collectionViewSize * 0.5)
    }
    
}
