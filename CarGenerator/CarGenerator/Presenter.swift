//
//  Presentor.swift
//  CarGenerator
//
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import RxSwift


class Presenter {
   
     weak var view: MainView?
     private var disposeBag = DisposeBag()
        let locp = LocalProvider()

    enum Colors:String, CaseIterable {
        case red
        case white
        case black
        case gray
        case blue
        case green
        case yellow
    }
    
    let brands  = [
        "Mersedess",
        "Audi",
        "BMW",
        "Nissan",
        "Fiat",
        "Renault",
        "Honda",
        "Mazda",
        "Ford",
        "Mini"
    ]
    
    func fillBrands(){
        
        for i in brands{
            locp.fillBrands(brand: i)
        }
    }
    func getRandomBrand()->Brand{
        var res:Brand?
        _ = locp.getBrands().subscribe(
            onNext: { n in
            
          res = n.randomElement()
            
        })
        return res!
    }
    
    func fillCars(){
        
             for _ in 0..<100 {
                locp.fillCar(car: self.generateCar(), brand: getRandomBrand())
                //print(index)
            }
        
        
    }
func getCars(){
    
   DispatchQueue.global(qos: .background).async {
    
        self.locp.deleteData()
        self.fillBrands()
        self.fillCars()
    DispatchQueue.main.async {
        self.locp.getCars().subscribe(
            
            onNext: { n in
                self.view?.showData(array: n)
                
        }, onError: { err in
            print(err.localizedDescription)
            
        }, onCompleted: {
            //print(" onCompleted")
        }, onDisposed: {
            //print("onDisposed")
        }).disposed(by: self.disposeBag)
    }
    
    }}
        
 
    

    
    func generateCar() -> MyCar{
        
        let car:MyCar = MyCar(year: Int64.random(in: 2003..<2020), color: Colors.allCases.randomElement()!.rawValue, capacity: Double.random(in: 1..<9))
        return car
    }
    
}
