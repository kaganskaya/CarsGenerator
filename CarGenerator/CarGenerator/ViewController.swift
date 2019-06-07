//
//  ViewController.swift
//  CarGenerator
//
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    let presenter = Presenter()

    var cars:[Car] = []
    var car:String = " "
    override func viewDidLoad() {
       super.viewDidLoad()
        presenter.view = self
        presenter.getCars()
        
        tableView.delegate = self
        tableView.dataSource = self
        print(cars.count)
        if self.cars.isEmpty {
        tableView.isHidden = true
            activity.startAnimating()
        }
        
        
    }

    
}
extension ViewController: MainView, UITableViewDelegate, UITableViewDataSource {

    
    func showData(array:[Car]) {
        DispatchQueue.main.async {
            
        
        self.cars = array
        
        if  array.isEmpty == false {
            self.tableView.isHidden = false
            self.activity.stopAnimating()
            self.activity.isHidden = true
        }

        self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as? TableViewCell
        
        cell?.label.text = cars[indexPath.row].year.description
        return cell!
    }
    
    
    
    
}
