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
    
    fileprivate var cities: [City]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cities = BudgetDatabase.shared.allCities().sorted { $0.name < $1.name }
    }
    
    @IBAction func pressedStartButton() {
        let budgetMapStoryboard = UIStoryboard(name: "BudgetMap", bundle: .main)
        guard let budgetMapVC = budgetMapStoryboard.instantiateInitialViewController() as? BudgetMapViewController else {
            return
        }
        
        let cityIndex = self.cityPicker.selectedRow(inComponent: 0)
        let city = self.cities[cityIndex]
        
        guard let budgetItems = BudgetDatabase.shared.budgetItems(city: city) else {
            return
        }
        
        let departmentInfos = budgetItems.map { DepartmentInfo(category: $0.category, caption: $0.title, details: $0.description, allocation: $0.percentage) }
        
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
        
        return self.cities[row].name
    }
    
}
