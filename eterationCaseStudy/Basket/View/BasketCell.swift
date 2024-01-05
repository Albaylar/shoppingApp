//
//  BasketCell.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import UIKit
import SnapKit



class BasketCell: UITableViewCell {
    
    let productNameLabel = UILabel()
        let productPriceLabel = UILabel()
        let quantityLabel = UILabel()
        let incrementButton = UIButton()
        let decrementButton = UIButton()
    var onQuantityChanged: ((Int) -> Void)?

        // Bu fonksiyon, arayüz öğelerini yapılandırır ve hücreye ekler.
        func setupViews() {
            

            
            productNameLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(productNameLabel)
            productNameLabel.snp.makeConstraints { make in
                make.left.top.equalToSuperview()
            }
            productPriceLabel.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(productPriceLabel)
            productPriceLabel.snp.makeConstraints { make in
                make.top.equalTo(productNameLabel.snp.bottom).offset(2)
                make.left.equalToSuperview()
            }
            decrementButton.addTarget(self, action: #selector(decrementQuantity), for: .touchUpInside)
            decrementButton.translatesAutoresizingMaskIntoConstraints = false
            decrementButton.setTitle("-", for: .normal)
            decrementButton.backgroundColor = .blue
            contentView.addSubview(decrementButton)
            decrementButton.snp.makeConstraints { make in
                make.left.equalTo(productNameLabel.snp.right).offset(15)
                make.top.equalToSuperview()
            }
            quantityLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(quantityLabel)
            quantityLabel.snp.makeConstraints { make in
                make.left.equalTo(decrementButton.snp.right)
                make.centerY.equalTo(decrementButton.snp.centerY)
            }
            incrementButton.addTarget(self, action: #selector(incrementQuantity), for: .touchUpInside)
            incrementButton.translatesAutoresizingMaskIntoConstraints = false
            incrementButton.setTitle("+", for: .normal)
            incrementButton.backgroundColor = .blue
            contentView.addSubview(incrementButton)
            incrementButton.snp.makeConstraints { make in
                make.left.equalTo(quantityLabel.snp.right)
                make.centerY.equalTo(decrementButton.snp.centerY)
            }
        }
        
    @objc func incrementQuantity() {
            if let currentQuantity = Int(quantityLabel.text ?? "0") {
                let newQuantity = currentQuantity + 1
                quantityLabel.text = "\(newQuantity)"
                onQuantityChanged?(newQuantity)
            }
        }
        
        @objc func decrementQuantity() {
            if let currentQuantity = Int(quantityLabel.text ?? "0"), currentQuantity > 1 {
                let newQuantity = currentQuantity - 1
                quantityLabel.text = "\(newQuantity)"
                onQuantityChanged?(newQuantity)
            }
        }
        
        // Hücre içeriğini yapılandırmak için bir fonksiyon
        func configure(with item: CartItem) {
    
            productNameLabel.text = item.productName
            productPriceLabel.text = "\(item.price)₺"
            quantityLabel.text = "\(item.quantity)"
        }}
