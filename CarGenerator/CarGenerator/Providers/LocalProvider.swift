//
//  LocalProvider.swift
//  CarGenerator
//
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import RxSwift


class LocalProvider{
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var managedContext = appDelegate!.persistentContainer.viewContext
    let con = NSPersistentContainer(name: "CarGenerator")
    
    
    
    func fillBrands(brand:String) {
        do {
           
                let entity =  NSEntityDescription.entity(forEntityName: "Brand",in: self.managedContext)!

                let entityItem = NSManagedObject(entity: entity,insertInto: self.managedContext) as! Brand

                entityItem.name = brand


            do{
                try self.managedContext.save()

                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
            
            }}
    
    }
    func getCars()->Observable<[Car]>{

        return Observable<[Car]>.create { observer -> Disposable in
       
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        
            fetchRequest.predicate = NSPredicate(format: "color == %@", "red")
       
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
       
            backgroundContext.parent = self.managedContext
                
        var ids:[NSManagedObjectID] = []
        
        backgroundContext.perform{
        
            do {
                
              let res = try backgroundContext.fetch(fetchRequest) as! [Car]
                
                
                let objects  = backgroundContext.registeredObjects
                
                   _ = objects.map({ i in
                        ids.append(i.objectID)
                    })
                
                 let changes = [NSUpdatedObjectsKey: ids]
                
                    observer.onNext(res)
                    observer.onCompleted()
               
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.managedContext])

            }catch{}
            
          
 
        }
        
       
        return Disposables.create(with: {})
        
        }
    }
    
    func deleteData(){
        
        
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        let fetchRequest1 =  NSFetchRequest<NSFetchRequestResult>(entityName: "Brand")

        do {
            
            let fetchedResults =  try managedContext.fetch(fetchRequest)
            let fetchedResults1 =  try managedContext.fetch(fetchRequest1)

            for entity in fetchedResults {
                
                managedContext.delete(entity as! NSManagedObject)
            }
            for entity in fetchedResults1 {
                
                managedContext.delete(entity as! NSManagedObject)
            }
            
            do{
                try managedContext.save()
            } catch let error as NSError {
                print(error)
            }
            
            
        }catch let error as NSError {
            
            print("Detele all my data in error : \(error) \(error.userInfo)")
            
        }
        
    }
    func getBrands()->Observable<[Brand]>{

       return Observable<[Brand]>.create { observer -> Disposable in
        
            
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Brand")

            do {
                
                let res = try self.managedContext.fetch(fetchRequest) as!  [Brand]
                observer.onNext(res)
                observer.onCompleted()
            }
            catch let error {
                print("Fethcing in background failed with error: \(error)")
            }
        
        
        
        return Disposables.create(with: {})
            
        }
        
    }
    
    
    func fillCar(car:MyCar){
        
        
        do {
            
            let entity =  NSEntityDescription.entity(forEntityName: "Car",in: self.managedContext)!
            
            let entityItem = NSManagedObject(entity: entity,insertInto: self.managedContext) as! Car
            
                        entityItem.capacity = car.capacity
                        entityItem.color = car.color
                        entityItem.year  = car.year
                        entityItem.hasBrand = car.brand
                        
            
            do{
                try self.managedContext.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
               
                
            }
            
        }catch let error as NSError {
            print("Could not do. \(error), \(error.userInfo)")
        }
        
        }
    
    
    }
