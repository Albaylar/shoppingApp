//
//  FavoritesViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import Foundation
import CoreData
import UIKit


import Foundation

class FavoriteViewModel {
    
    var favoriteCars: [FavoriteCar] = []
    
    // Fetch Favorites
    func fetchFavorites() {
        favoriteCars = CoreDataManager.shared.fetchFavorites()
    }
    
    // Delete Favorite Car
    func deleteFavoriteCar(withId id: String) {
        CoreDataManager.shared.deleteFavoriteCar(withId: id)

        fetchFavorites()
    }
}
extension FavoriteViewModel {
    func isCarFavorite(carId: String) -> Bool {
        return favoriteCars.contains(where: { $0.id == carId })
    }
}

