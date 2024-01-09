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
    var car: Car
    var isFavorite: Bool = false
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

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", carId)

        do {
            let results = try managedContext.fetch(fetchRequest)
            let isFav = results.count > 0
            self.isFavorite = isFav 
            onFavoriteStatusChanged?(isFav)
        } catch let error as NSError {
            print("Error occurred: \(error), \(error.userInfo)")
            DispatchQueue.main.async {
                self.onFavoriteStatusChanged?(self.isFavorite)
            }
        }
    }

    func updateFavoriteStatus(isFavorite: Bool) {
        guard let id = car.id, let idInt = Int(id) else { return }
        if isFavorite {
            CoreDataManager.shared.saveCarsToCoreData(data: car)
        } else {
            CoreDataManager.shared.removeCarItemFromCoreData(id: idInt)
        }
        onFavoriteStatusChanged?(isFavorite)
        self.isFavorite = isFavorite
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdatedInDetail"), object: nil, userInfo: ["carId": car.id ?? 0])

    }
    
}


