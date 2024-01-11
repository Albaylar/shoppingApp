//
//  CartViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import Foundation

class BasketViewModel {
    
     var basketItems: [CartItem] = []

    func loadBasketItems() {
        let fetchedItems = CoreDataManager.shared.fetchBasketItems()
        var groupedItems = [String: CartItem]()

        for entity in fetchedItems {
            guard let id = entity.id, let name = entity.name, let priceString = entity.price, let price = Double(priceString) else { continue }
            
            if let existingItem = groupedItems[id] {
                let updatedQuantity = existingItem.quantity + 1
                groupedItems[id] = CartItem(productId: id, productName: name, quantity: updatedQuantity, price: price)
            } else {
                groupedItems[id] = CartItem(productId: id, productName: name, quantity: 1, price: price)
            }
        }
        basketItems = Array(groupedItems.values)
    }

    func removeProductFromBasket(atIndex index: Int) {
        let productId = basketItems[index].productId
        CoreDataManager.shared.removeCarFromCart(id: productId)
        loadBasketItems()
        NotificationCenter.default.post(name: NSNotification.Name("BasketUpdated"), object: nil)

    }

    func incrementQuantity(atIndex index: Int) {
        basketItems[index].quantity += 1
    }

    func decrementQuantity(atIndex index: Int) {
        if basketItems[index].quantity > 1 {
            basketItems[index].quantity -= 1

        }
    }
    func updateQuantity(atIndex index: Int, newQuantity: Int) {
        guard index < basketItems.count else {
            print("Index out of range")
            return
        }
        basketItems[index].quantity = newQuantity
    }

    var totalPrice: Double {
        basketItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}


