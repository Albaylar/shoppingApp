//
//  CartViewModel.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import Foundation

class CartViewModel {
    // Sepetteki ürünleri tutan array
    private(set) var cartItems: [CartItem] = []
    
    // Sepete ürün ekler
    func addProductToCart(productId: String, productName: String, price: Double) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            // Ürün zaten sepetteyse miktarını artır
            cartItems[index].quantity += 1
        } else {
            // Ürün sepette yoksa yeni bir cart item oluştur ve ekle
            let newItem = CartItem(productId: productId, productName: productName, quantity: 1, price: price)
            cartItems.append(newItem)
        }
        updateCart()
    }
    
    // Sepetten ürün çıkarır
    func removeProductFromCart(productId: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            cartItems.remove(at: index)
            updateCart()
        }
    }
    
    // Sepetteki bir ürünün miktarını artırır
    func incrementQuantity(productId: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            cartItems[index].quantity += 1
            updateCart()
        }
    }
    
    // Sepetteki bir ürünün miktarını azaltır
    func decrementQuantity(productId: String) {
        if let index = cartItems.firstIndex(where: { $0.productId == productId }), cartItems[index].quantity > 1 {
            cartItems[index].quantity -= 1
            updateCart()
        }
    }
    
    // Sepeti ve ilgili görünümü güncelle
    private func updateCart() {
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    
    // Sepetin toplam fiyatını hesaplar
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}

// Notification için uzantı
extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}

