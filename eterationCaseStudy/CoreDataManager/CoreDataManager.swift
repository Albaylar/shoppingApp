//
//  CoreDataManager.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//
import UIKit
import CoreData

import UIKit
import CoreData

final class CoreDataManager {
    
    //MARK: - Properties
    static let shared = CoreDataManager()
    
    //MARK: - Functions
    
    func fetchAllCarItems() -> [Entity] {
        var coreDataItems = [Entity]()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        
        do {
            coreDataItems = try managedObjectContext!.fetch(fetchRequest)
        } catch {
            print("Fetching from Core Data failed: \(error)")
        }
        return coreDataItems
    }
    
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
    
    func deleteAllCoreDataObjects(context: NSManagedObjectContext) {
        do {
            let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
            let objects = try context.fetch(fetchRequest)
            _ = objects.map({context.delete($0)})
            try context.save()
        } catch {
            print("Deleting error: \(error)")
        }
    }
    
    // Sepett
    func saveCarToCart(data: Car?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "NewEntity", in: managedObjectContext),
           let basketItem = NSManagedObject(entity: entity, insertInto: managedObjectContext) as? NewEntity {
            
            basketItem.name = data?.name
            basketItem.price = data?.price
            basketItem.id = data?.id 
            
            do {
                try managedObjectContext.save()
                print("Car saved to cart")
            } catch {
                print("Error saving car to cart: \(error.localizedDescription)")
            }
        }
    }
    func removeCarFromCart(id: String?) {
        guard let carId = id, let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Invalid ID or AppDelegate not found")
            return
        }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", carId)

        do {
            let fetchedResults = try managedObjectContext.fetch(fetchRequest)
            if let entityToDelete = fetchedResults.first as? NSManagedObject {
                managedObjectContext.delete(entityToDelete)
                try managedObjectContext.save()
                print("Car removed from cart")
            } else {
                print("Car not found in cart")
            }
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




