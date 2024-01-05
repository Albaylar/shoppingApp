//
//  CarDetailViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import Foundation
import CoreData
import UIKit

class CarDetailViewModel {
    private var car: Car

    // Bir closure tanımlayarak favori durumu değiştiğinde bildirim yapılır
    var onFavoriteStatusChanged: ((Bool) -> Void)?

    init(car: Car) {
        self.car = car
    }

    var name: String {
        return car.name ?? "Unknown"
    }

    var formattedPrice: String {
        return "\(car.price ?? "N/A")"
    }

    var description: String {
        return car.description ?? "No description available."
    }

    var imageURL: URL? {
        return URL(string: car.image ?? "")
    }

    var brand: String {
        return car.brand ?? ""
    }

    var id: String? {
        return car.id
    }

    func checkIfFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let carId = car.id else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity") // Entity adınızı girin
        fetchRequest.predicate = NSPredicate(format: "id == %@", carId)

        do {
            let results = try managedContext.fetch(fetchRequest)
            onFavoriteStatusChanged?(results.count > 0)
        } catch let error as NSError {
            print("Favori durumu kontrol edilirken hata oluştu: \(error), \(error.userInfo)")
            onFavoriteStatusChanged?(false)
        }
    }

    func updateFavoriteStatus(isFavorite: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let carId = car.id else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        if isFavorite {
            // Favorilere ekle
            let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)! // Entity adınızı girin
            let newFavorite = NSManagedObject(entity: entity, insertInto: managedContext)
            newFavorite.setValue(carId, forKey: "id")
            // Diğer özellikleri de ayarlayın
        } else {
            // Favorilerden çıkar
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity") // Entity adınızı girin
            fetchRequest.predicate = NSPredicate(format: "id == %@", carId)

            do {
                let results = try managedContext.fetch(fetchRequest)
                for object in results {
                    if let objectToDelete = object as? NSManagedObject {
                        managedContext.delete(objectToDelete)
                    }
                }
            } catch let error as NSError {
                print("Favorilerden çıkarırken hata meydana geldi: \(error), \(error.userInfo)")
            }
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Favorilere eklerken/kaldırırken hata meydana geldi: \(error), \(error.userInfo)")
        }

        // Favori durumunu güncelle
        onFavoriteStatusChanged?(isFavorite)
    }
}

