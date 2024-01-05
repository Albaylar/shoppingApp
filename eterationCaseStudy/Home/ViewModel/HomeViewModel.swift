//
//  HomeViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation
enum SortOption {
    case priceAscending
    case priceDescending
    case dateAscending
    case dateDescending
}


class HomeViewModel {
    var allCars: [Car] = [] // Tüm araçların listesi
    var cars: [Car] = [] // Filtrelenmiş veya gösterilecek araçların listesi
    private let carService = CarService.shared
    private let debouncer = Debouncer(delay: 0.5)
    
    func loadAllCars(completion: @escaping () -> Void) {
        carService.getCars { [weak self] cars in
            self?.allCars = cars // API'den dönen tüm araçlar
            self?.cars = cars    // Başlangıçta tüm araçları göstermek için
            
            completion()
        } failure: { error in
            print(error)
        }
    }
    
    func performSearch(with query: String, completion: @escaping () -> Void) {
        debouncer.debounce { [weak self] in
            if query.isEmpty {
                self?.loadAllCars(completion: completion)
            } else {
                self?.carService.getCars { cars in
                    let filteredCars = cars.filter { car in
                        return car.name?.lowercased().contains(query.lowercased()) ?? false
                    }
                    self?.cars = filteredCars
                    completion()
                } failure: { error in
                    print(error)
                }
            }
        }
    }
    
    func filterCars(brand: String?, model: String?, sortOption: SortOption?) {
            // Filtreleme işlemleri...
            cars = allCars.filter { car in
                if let brand = brand?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                   let model = model?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
                   !brand.isEmpty, !model.isEmpty {
                    return car.brand?.lowercased() == brand && car.model?.lowercased() == model
                } else if let brand = brand?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), !brand.isEmpty {
                    return car.brand?.lowercased() == brand
                } else if let model = model?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), !model.isEmpty {
                    return car.model?.lowercased() == model
                } else {
                    return true
                }
            }

            // Sıralama işlemleri
            if let sortOption = sortOption {
                switch sortOption {
                case .priceAscending:
                    cars.sort { (Int($0.price ?? "") ?? 0) < (Int($1.price ?? "") ?? 0) }
                case .priceDescending:
                    cars.sort { (Int($0.price ?? "") ?? 0) > (Int($1.price ?? "") ?? 0) }
                case .dateAscending: break
                    // Burada tarihleri artan sırada sıralayabilirsiniz
                case .dateDescending: break
                    // Burada tarihleri azalan sırada sıralayabilirsiniz
                }
            }
        }
}




