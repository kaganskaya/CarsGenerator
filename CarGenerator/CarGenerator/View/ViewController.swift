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
    @IBOutlet weak var number: UITextField!
    
    @IBAction func buttonGenerate(_ sender: Any) {
        
        activity.isHidden = false
        activity.startAnimating()
        
        presenter.getCars(amount: Int(self.number.text! )!)
        
    }
    
    
    let presenter = Presenter()

    var cars:[Car] = []
    var car:String = " "
   
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        presenter.view = self

        tableView.delegate = self
        tableView.dataSource = self
        
        activity.isHidden = true
        
    }

    
}
extension ViewController: MainView, UITableViewDelegate, UITableViewDataSource {

    
    func showData(array:[Car]) {

        DispatchQueue.main.async {

            self.cars = array
        
            if  array.isEmpty == false {
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
        
            
            cell?.label.text = self.cars[indexPath.row].year.description
        
        return cell!
    }
    
    
    
    
}
