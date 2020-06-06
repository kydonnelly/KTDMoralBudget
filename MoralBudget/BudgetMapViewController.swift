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
    
    struct DraggingInfo {
        var allocation: Double
        var snapshotOffset: CGPoint
        var snapshotView: UIImageView
        var sourceIndexPath: IndexPath
        var targetIndexPath: IndexPath
    }
    
    @IBOutlet var collectionView: TreeMapCollectionView!
    
    // parallel arrays
    private var departments: [DepartmentInfo] = []
    private var allocations: [Double] = []
    
    private var draggingInfo: DraggingInfo?
    
    func setup(city: String, departments: [DepartmentInfo]) {
        self.navigationItem.title = city
        
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
        
        self.refresh(cell: cell, indexPath: indexPath)
        
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

extension BudgetMapViewController {
    
    func refresh(cell: BudgetMapCell, indexPath: IndexPath) {
        let department = self.department(indexPath: indexPath)
        let allocation = self.allocation(indexPath: indexPath)
        let allocationOffset = self.allocationOffset(indexPath: indexPath)
        
        cell.setup(departmentInfo: department, allocation: allocation, offset: allocationOffset)
    }
    
    func department(indexPath: IndexPath) -> DepartmentInfo {
        return self.departments[indexPath.row]
    }
    
    func allocation(indexPath: IndexPath) -> Double {
        return self.allocations[indexPath.row]
    }
    
    func adjustAllocation(indexPath: IndexPath, amount: Double) {
        self.allocations[indexPath.row] += amount
    }
    
    func allocationOffset(indexPath: IndexPath) -> Double {
        guard let draggingInfo = self.draggingInfo else {
            return 0
        }
        
        let source = draggingInfo.sourceIndexPath
        let target = draggingInfo.targetIndexPath
        
        guard source != target else {
            return 0
        }
        
        if indexPath == source {
            return -1 * draggingInfo.allocation
        } else if indexPath == target {
            return draggingInfo.allocation
        } else {
            return 0
        }
    }
    
}

extension BudgetMapViewController : CoinsDraggableProtocol {
    
    func didBeginDragging(coins: [UIImageView], touch: UITouch, view: UIView) {
        let touchPoint = touch.location(in: self.view)
        
        guard let sourceCell = self.collectionView.visibleCells.filter({$0.frame.contains(touchPoint)}).first else {
            return
        }
        guard let sourceIndexPath = self.collectionView.indexPath(for: sourceCell) else {
            return
        }
        
        let allocation = min(Double(coins.count) * 0.02, self.allocation(indexPath: sourceIndexPath))
        
        let snapshot = UIImage.snapshot(views: coins)
        let snapshotView = UIImageView(image: snapshot)
        
        self.view.addSubview(snapshotView)
        snapshotView.frame = self.view.convert(coins.frame.applying(.init(translationX: 2, y: -4)), from: view)
        let snapshotOffset = CGPoint(x: touchPoint.x - snapshotView.frame.origin.x,
                                     y: touchPoint.y - snapshotView.frame.origin.y)
        
        self.draggingInfo = DraggingInfo(allocation: allocation,
                                         snapshotOffset: snapshotOffset,
                                         snapshotView: snapshotView,
                                         sourceIndexPath: sourceIndexPath,
                                         targetIndexPath: sourceIndexPath)
    }
    
    func didContinueDragging(touch: UITouch, view: UIView) {
        guard var draggingInfo = self.draggingInfo else {
            return
        }
        
        let touchPoint = touch.location(in: self.view)
        let dragPoint = CGPoint(x: touchPoint.x - draggingInfo.snapshotOffset.x,
                                y: touchPoint.y - draggingInfo.snapshotOffset.y)
        
        draggingInfo.snapshotView.frame.origin = dragPoint
        
        let oldHoverPath = draggingInfo.targetIndexPath
        let oldHoverCell = self.collectionView.cellForItem(at: oldHoverPath) as? BudgetMapCell
        oldHoverCell?.transform = .identity
        
        defer {
            if let oldCell = oldHoverCell {
                self.refresh(cell: oldCell, indexPath: oldHoverPath)
            }
        }
        
        guard let hoverCell = self.collectionView.visibleCells.filter({$0.frame.contains(dragPoint)}).first as? BudgetMapCell,
              let hoverIndexPath = self.collectionView.indexPath(for: hoverCell) else {
            self.clearDrag()
            return
        }
        
        hoverCell.superview?.bringSubviewToFront(hoverCell)
        hoverCell.transform = .init(scaleX: 1.1, y: 1.1)
        draggingInfo.targetIndexPath = hoverIndexPath
        self.draggingInfo = draggingInfo
        
        self.refresh(cell: hoverCell, indexPath: hoverIndexPath)
    }
    
    func didEndDragging(touch: UITouch, view: UIView) {
        guard let draggingInfo = self.draggingInfo else {
            return
        }
        
        defer {
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        }
        
        let touchPoint = touch.location(in: self.view)
        let dragPoint = CGPoint(x: touchPoint.x - draggingInfo.snapshotOffset.x,
                                y: touchPoint.y - draggingInfo.snapshotOffset.y)
        
        draggingInfo.snapshotView.frame.origin = dragPoint
        
        let oldHoverPath = draggingInfo.targetIndexPath
        let oldHoverCell = self.collectionView.cellForItem(at: oldHoverPath) as? BudgetMapCell
        oldHoverCell?.transform = .identity
        
        guard let hoverCell = self.collectionView.visibleCells.filter({$0.frame.contains(dragPoint)}).first as? BudgetMapCell,
              let hoverIndexPath = self.collectionView.indexPath(for: hoverCell) else {
            self.clearDrag()
            return
        }
        
        self.adjustAllocation(indexPath: draggingInfo.sourceIndexPath, amount: -1 * draggingInfo.allocation)
        self.adjustAllocation(indexPath: hoverIndexPath, amount: draggingInfo.allocation)
        
        self.clearDrag()
    }
    
    func didCancelDragging(touch: UITouch, view: UIView) {
        guard let draggingInfo = self.draggingInfo else {
            return
        }
        
        let oldHoverPath = draggingInfo.targetIndexPath
        let oldHoverCell = self.collectionView.cellForItem(at: oldHoverPath) as? BudgetMapCell
        oldHoverCell?.transform = .identity
        
        self.clearDrag()
        self.refreshData()
    }
    
    private func clearDrag() {
        self.draggingInfo?.snapshotView.removeFromSuperview()
        self.draggingInfo = nil
    }
    
}
