//
//  BudgetMapViewController.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 3/17/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import KTDTreeMap
import UIKit

class BudgetMapViewController : UIViewController {
    
    @IBOutlet var collectionView: TreeMapCollectionView!
    
    private var draggingSnapshotOffset: CGPoint?
    private var draggingSnapshotView: UIImageView?
    private var draggingHoverCell: UICollectionViewCell?
    
    // parallel arrays
    private var departments: [DepartmentInfo] = []
    private var allocations: [Double] = []
    
    func setup(departments: [DepartmentInfo]) {
        self.departments = departments
        self.allocations = departments.map { $0.allocation }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    private func refreshData() {
        self.collectionView.reloadData()
    }
    
}

extension BudgetMapViewController : TreeMapCollectionViewDataSource {
    
    func weights(for treeMap: TreeMapCollectionView) -> [CGFloat] {
        return self.allocations.map { CGFloat($0) }
    }
    
    func minimumCellSize(for treeMap: TreeMapCollectionView) -> CGSize {
        return CGSize(width: 96, height: 96)
    }
    
}

extension BudgetMapViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.departments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BudgetMapCell", for: indexPath) as? BudgetMapCell else {
            preconditionFailure("Missing expected table cell type!")
        }
        
        let department = self.departments[indexPath.row]
        let allocation = self.allocations[indexPath.row]
        
        cell.setup(departmentInfo: department, allocation: allocation)
        
        return cell
    }
    
}

extension BudgetMapViewController : UICollectionViewDelegate {
    
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

extension BudgetMapViewController {
    
    @IBAction func tappedNextButton() {
        self.showResultsScreen()
    }
    
    func showResultsScreen() {
        let brsb = UIStoryboard(name: "BudgetResults", bundle: .main)
        guard let brvc = brsb.instantiateInitialViewController() as? BudgetResultsViewController else {
            preconditionFailure("unexpected storyboard setup")
        }
        
        brvc.setup(departments: self.departments, allocations: self.allocations)
        self.navigationController?.pushViewController(brvc, animated: true)
    }
    
}

extension BudgetMapViewController : CoinsDraggableProtocol {
    
    func didBeginDragging(coins: [UIImageView], touch: UITouch, view: UIView) {
        let snapshot = UIImage.snapshot(views: coins)
        let snapshotView = UIImageView(image: snapshot)
        
        self.view.addSubview(snapshotView)
        let touchPoint = touch.location(in: self.view)
        snapshotView.frame = self.view.convert(coins.frame.applying(.init(translationX: 2, y: -4)), from: view)
        
        self.draggingSnapshotView = snapshotView
        self.draggingSnapshotOffset = CGPoint(x: touchPoint.x - snapshotView.frame.origin.x,
                                              y: touchPoint.y - snapshotView.frame.origin.y)
    }
    
    func didContinueDragging(touch: UITouch, view: UIView) {
        guard let dragView = self.draggingSnapshotView, let dragOffset = self.draggingSnapshotOffset else {
            return
        }
        
        let touchPoint = touch.location(in: self.view)
        let dragPoint = CGPoint(x: touchPoint.x - dragOffset.x, y: touchPoint.y - dragOffset.y)
        
        dragView.frame.origin = dragPoint
        
        self.draggingHoverCell?.contentView.transform = .identity
        if let hoverCell = self.collectionView.visibleCells.filter({$0.frame.contains(dragPoint)}).first {
            hoverCell.contentView.transform = .init(scaleX: 1.1, y: 1.1)
            self.draggingHoverCell = hoverCell
        } else {
            self.draggingHoverCell = nil
        }
    }
    
    func didEndDragging(touch: UITouch, view: UIView) {
        guard let dragView = self.draggingSnapshotView, let dragOffset = self.draggingSnapshotOffset else {
            return
        }
        
        let touchPoint = touch.location(in: self.view)
        let dragPoint = CGPoint(x: touchPoint.x - dragOffset.x, y: touchPoint.y - dragOffset.y)
        dragView.frame.origin = dragPoint
        
        self.draggingHoverCell?.contentView.transform = .identity
        self.draggingHoverCell = nil
        
        if let hoverCell = self.collectionView.visibleCells.filter({$0.frame.contains(dragPoint)}).first {
            // TODO: add allocation
        }
        
        self.draggingSnapshotView?.removeFromSuperview()
        self.draggingSnapshotView = nil
    }
    
}
