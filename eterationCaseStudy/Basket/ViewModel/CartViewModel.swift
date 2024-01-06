//
//  CartViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import Foundation

class CartViewModel {
    private(set) var cartItems: [CartItem] = []
    
    
    func addProductToCart(productId: String, productName: String, priceString: String) {
            guard let price = Double(priceString) else {
                print("Fiyat dönüştürülemedi")
                return
            }
            if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
                
                cartItems[index].quantity += 1
            } else {
                let newItem = CartItem(productId: productId, productName: productName, quantity: 1, price: price)
                cartItems.append(newItem)
            }
            updateCart()
        }
    
    func removeProductFromCart(productId: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            cartItems.remove(at: index)
            updateCart()
        }
    }
    func incrementQuantity(productId: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            cartItems[index].quantity += 1
            updateCart()
        }
    }
    
    func decrementQuantity(productId: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId }), cartItems[index].quantity > 1 {
            cartItems[index].quantity -= 1
            updateCart()
        }
    }
    
    private func updateCart() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
        
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}
extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}

