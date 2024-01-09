//
//  CoreDataManager.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//
import UIKit
import CoreData


final class CoreDataManager {
    
    //MARK: - Properties
    static let shared = CoreDataManager()
        private let context: NSManagedObjectContext

        private init() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("AppDelegate not accessible.")
            }
            context = appDelegate.persistentContainer.viewContext
        }
    
    //MARK: - Functions
    
//    func fetchAllCarItems() -> [Entity] {
//        var coreDataItems = [Entity]()
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        let managedObjectContext = appDelegate?.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
//        
//        do {
//            coreDataItems = try managedObjectContext!.fetch(fetchRequest)
//        } catch {
//            print("Fetching from Core Data failed: \(error)")
//        }
//        return coreDataItems
//    }
    
    func saveCarsToCoreData(data: Car?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedObjectContext!),
           let taskItem = NSManagedObject(entity: entity, insertInto: managedObjectContext!) as? Entity {
            
            taskItem.name = data?.name
            taskItem.price = data?.price
            taskItem.id = data?.id
            do {
                try managedObjectContext?.save()
                print("Saved to Core Data")
            } catch let error {
                print("Saving to Core Data failed: \(error.localizedDescription)")
            }
        }
    }
    
    func isCarSaved(id: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate not found")
            return false
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return result.count > 0
        } catch {
            print("Error checking if movie is saved: \(error)")
            return false
        }
    }
    
    func removeCarItemFromCoreData(id: Int) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let result = try managedObjectContext?.fetch(fetchRequest).first {
                managedObjectContext?.delete(result)
                try managedObjectContext?.save()
                print("Removed from Core Data")
            } else {
                print("Car not found in Core Data")
            }
        } catch let error {
            print("Removing from Core Data failed: \(error.localizedDescription)")
        }
    }
    
    // Sepett
    func saveCarToCart(data: Car?, quantity: Int = 1) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let carData = data else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let basketItem = NewEntity(context: managedObjectContext)
        basketItem.name = carData.name
        basketItem.price = carData.price
        basketItem.id = carData.id
        
        do {
            try managedObjectContext.save()
            print("Car saved to cart with quantity \(quantity)")
        } catch {
            print("Error saving car to cart: \(error.localizedDescription)")
        }
    }

    func removeCarFromCart(id: String?) {
        guard let carId = id, let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Invalid ID or AppDelegate not found")
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NewEntity> = NewEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", carId)

        do {
            let fetchedResults = try managedObjectContext.fetch(fetchRequest)
            for entity in fetchedResults {
                managedObjectContext.delete(entity)
            }
            try managedObjectContext.save()
            print("All cars with ID \(carId) removed from cart")
        } catch {
            print("Error removing car from cart: \(error.localizedDescription)")
        }
    }


    func fetchBasketItems() -> [NewEntity] {
        var coreDataItems = [NewEntity]()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NewEntity>(entityName: "NewEntity")
        
        do {
            coreDataItems = try managedObjectContext!.fetch(fetchRequest)
        } catch {
            print("Fetching from Core Data failed: \(error)")
        }
        return coreDataItems
    }
    



}




