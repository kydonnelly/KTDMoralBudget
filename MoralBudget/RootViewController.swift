//
//  RootViewController.swift
//  MoralBudget
//
//  Created by Kyle Donnelly on 2/15/20.
//  Copyright © 2020 Kyle Donnelly. All rights reserved.
//

import UIKit

class RootViewController : UIViewController {
    
    @IBOutlet var cityPicker: UIPickerView!
    
    fileprivate var cities: [String] {
        return BudgetDatabase.shared.allCities
    }
    
    @IBAction func pressedStartButton() {
        let budgetMapStoryboard = UIStoryboard(name: "BudgetMap", bundle: .main)
        guard let budgetMapVC = budgetMapStoryboard.instantiateInitialViewController() as? BudgetMapViewController else {
            return
        }
        
        let cityIndex = self.cityPicker.selectedRow(inComponent: 0)
        let city = self.cities[cityIndex]
        
        let departmentInfos = BudgetDatabase.shared.departmentInfos(city: city)
        
        budgetMapVC.setup(city: city, departments: departmentInfos)
        
        self.navigationController?.pushViewController(budgetMapVC, animated: true)
    }
    
}

extension RootViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.cities.count
    }
    
}

extension RootViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard component == 0 else {
            return nil
        }
        
        return self.cities[row]
    }
    
}
