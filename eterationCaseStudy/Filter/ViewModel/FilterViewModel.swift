//
//  FilterViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation

import Foundation

class FilterViewModel {
    var brands: [String] = []
    var models: [String] = []
    var sortOptions = ["Old to new", "New to old", "Price high to low", "Price low to high"]
    var allCars: [Car] = []  // Add property to store all cars
    var cars : [Car] = []
    
    func loadFilterOptions(completion: @escaping () -> Void) {
        CarService.shared.getCars { [self] response in
            // Store all cars
            self.allCars = response
            
            let uniqueBrands = Set(response.compactMap { $0.brand }).sorted()
            let uniqueModels = Set(response.compactMap { $0.model }).sorted()
            
            self.models = Array(uniqueModels)
            self.brands = Array(uniqueBrands)
            
            completion()
        } failure: { error in
            print(error)
        }
    }
    
    func getAllCars() -> [Car] {
        return allCars
    }
    
    func filterBrands(with searchText: String) -> [String] {
        if searchText.isEmpty {
            return brands
        } else {
            return brands.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func filterModels(with searchText: String) -> [String] {
        if searchText.isEmpty {
            return models
        } else {
            return models.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func filterCars(brand: String?, model: String?, sortOption: SortOption?) {
        // Önce filtreleme
        cars = allCars.filter { car in
            var matchesBrand = true
            var matchesModel = true
            
            if let brand = brand, !brand.isEmpty {
                matchesBrand = car.brand?.lowercased() == brand.lowercased()
            }
            
            if let model = model, !model.isEmpty {
                matchesModel = car.model?.lowercased() == model.lowercased()
            }
            
            return matchesBrand && matchesModel
        }
        
        // Ardından sıralama
        if let sortOption = sortOption {
            switch sortOption {
            case .priceAscending:
                cars.sort { (Int($0.price ?? "") ?? 0) < (Int($1.price ?? "") ?? 0) }
            case .priceDescending:
                cars.sort { (Int($0.price ?? "") ?? 0) > (Int($1.price ?? "") ?? 0) }
                // Diğer sıralama seçenekleri buraya eklenebilir.
            case .dateAscending:
                print("")
            case .dateDescending:
                print("")
            }
        }
    }
    
}


