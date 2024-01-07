//
//  HomeViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import Foundation

final class HomeViewModel {
    var allCars: [Car] = []
    var cars: [Car] = []
    
    private let carService = CarService.shared
    private let debouncer = Debouncer(delay: 0.5)
    
    private var currentPage = 1
        private var isFetchingMoreCars = false
        var hasMoreCarsToLoad: Bool = true
    
    func loadAllCars(completion: @escaping () -> Void) {
        carService.getCars { [weak self] cars in
            self?.allCars = cars
            self?.cars = Array(cars.prefix(4))
            self?.currentPage = 1
            self?.hasMoreCarsToLoad = cars.count > 4
            completion()
        } failure: { error in
            print(error)
        }
    }

    func performSearch(with query: String, completion: @escaping () -> Void) {
        debouncer.debounce { [weak self] in
            if query.isEmpty {
                self?.cars = self?.allCars ?? []
                completion()
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

    func loadMoreCars(completion: @escaping () -> Void) {
        guard hasMoreCarsToLoad && !isFetchingMoreCars else {
            return
        }
        isFetchingMoreCars = true
        currentPage += 1
        let nextCars = Array(allCars.prefix(4 * currentPage))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.cars = nextCars
            self.hasMoreCarsToLoad = self.allCars.count > nextCars.count
            self.isFetchingMoreCars = false
            completion()
        }
    }

    func filterCars(brand: String?, model: String?, sortOption: SortOption?) {
            cars = allCars.filter { car in
                let matchesBrand = brand == nil || brand!.isEmpty || car.brand?.lowercased() == brand!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                let matchesModel = model == nil || model!.isEmpty || car.model?.lowercased() == model!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
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
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: dateString)
}






