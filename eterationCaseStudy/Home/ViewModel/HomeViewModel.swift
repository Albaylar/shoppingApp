//
//  HomeViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation



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
            cars = allCars.filter { car in
                var matchesBrand = brand == nil || brand!.isEmpty || car.brand?.lowercased() == brand!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                var matchesModel = model == nil || model!.isEmpty || car.model?.lowercased() == model!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                return matchesBrand && matchesModel
            }
            
            if let sortOption = sortOption {
                switch sortOption {
                case .priceAscending:
                    cars.sort { (Double($0.price ?? "") ?? 0.0) < (Double($1.price ?? "") ?? 0.0) }
                case .priceDescending:
                    cars.sort { (Double($0.price ?? "") ?? 0.0) > (Double($1.price ?? "") ?? 0.0) }
                case .dateAscending:
                    cars.sort { parseDate($0.createdAt ?? "") ?? Date.distantPast < parseDate($1.createdAt ?? "") ?? Date.distantPast }
                case .dateDescending:
                    cars.sort { parseDate($0.createdAt ?? "") ?? Date.distantPast > parseDate($1.createdAt ?? "") ?? Date.distantPast }
                }
            }
        }
    }

func parseDate(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Milisaniyeler için "SSS" eklendi
    return dateFormatter.date(from: dateString)
}






