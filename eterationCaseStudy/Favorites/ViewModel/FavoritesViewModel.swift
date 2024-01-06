//
//  FavoritesViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import Foundation

import CoreData
import UIKit


class FavoriteViewModel {

    var favoriteCars: [FavoriteCar] = []
    

    func fetchFavorites() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")

        do {
            let fetchedCars = try managedContext.fetch(fetchRequest)
            favoriteCars = fetchedCars.compactMap { managedObject in
                guard
                    let id = managedObject.value(forKey: "id") as? String,
                    let name = managedObject.value(forKey: "name") as? String,
                    let price = managedObject.value(forKey: "price") as? String
                else {
                    return nil
                }
                return FavoriteCar(id: id, name: name, price: price)
            }

        } catch let error as NSError {
            print("Could not fetch favorites. \(error), \(error.userInfo)")
        }
    }
    func deleteFavoriteCar(withId id: String) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Entity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            do {
                let results = try managedContext.fetch(fetchRequest)
                if let objectToDelete = results.first as? NSManagedObject {
                    managedContext.delete(objectToDelete)
                    try managedContext.save()
                }
            } catch let error as NSError {
                print("Deleting error: \(error.localizedDescription), \(error.userInfo)")
            }
        }
}
extension FavoriteViewModel {
    func isCarFavorite(carId: String) -> Bool {
        return favoriteCars.contains(where: { $0.id == carId })
    }
}

