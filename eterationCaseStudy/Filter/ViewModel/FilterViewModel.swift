//
//  FilterViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation

enum SortOption {
    case dateAscending, dateDescending, priceAscending, priceDescending
}

final class FilterViewModel {
    var brands: [String] = []
    var models: [String] = []
    var allCars: [Car] = []
    private var carService = CarService()

    
    
    func loadFilterOptions(completion: @escaping () -> Void) {
        CarService.shared.getCars { [self] response in
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
    
    
    
}


