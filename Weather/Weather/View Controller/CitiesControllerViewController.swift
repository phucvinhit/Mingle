//
//  CitiesControllerViewController.swift
//  Weather
//
//  Created by Vinh Pham on 9/2/19.
//  Copyright © 2019 Vinh Pham. All rights reserved.
//

import UIKit


protocol CitiesSelectedDelegate: NSObject {
    func citiesSelected(citiesSelected cities: [CityModel], controller: CitiesControllerViewController?)
}

class CitiesControllerViewController: UIViewController {
    
    var citiesDataSource = [CityModel]()
    var viewModel = CitiesViewModel()
    var selectedIndexes: [IndexPath] = []
    weak var delegate: CitiesSelectedDelegate?

    @IBOutlet weak var citiesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        citiesDataSource = viewModel.citiesDataSource
        
        citiesTable.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
    }
    
    
    @IBAction func buttonBackToForcecastPressed(_ sender: Any) {
        var citiesSelected: [CityModel] = []
        
        for (index, item) in citiesDataSource.enumerated() {
            if selectedIndexes.contains(IndexPath(row: index, section: 0)) {
                citiesSelected.append(item)
            }
        }
        
        delegate?.citiesSelected(citiesSelected: citiesSelected, controller: self)
    }
    
    public func citiesSelected(cites: [CityModel]) {
        for (index, item) in viewModel.citiesDataSource.enumerated() {
            if cites.contains(where: { (city) -> Bool in
                if city.cityCode == item.cityCode {
                    return true
                }else{
                    return false
                }
            }) {
                selectedIndexes.append(IndexPath(item: index, section: 0))
            }
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension CitiesControllerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(citiesDataSource[indexPath.row].cityName)"
        cell.selectionStyle = .none
    
        
        let selectedSectionIndexes = self.selectedIndexes
        if selectedSectionIndexes.contains(indexPath) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 15, y: cell.contentView.bounds.height + 1, width: cell.contentView.bounds.width - 15, height: 1), cornerRadius: 0 ).cgPath
        layer.fillColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        cell.contentView.layer.addSublayer(layer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If current cell is not present in selectedIndexes
        
        if !self.selectedIndexes.contains(indexPath) {
            self.selectedIndexes.append(indexPath)
        }else{
            if self.selectedIndexes.count == 1{
                return
            }
            
            let vowels: Set<IndexPath> = [indexPath]
            self.selectedIndexes.removeAll(where: { vowels.contains($0) })
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
