//
//  BasketCell.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import UIKit
import SnapKit

final class BasketCell: UITableViewCell {
    
    let productNameLabel = UILabel()
    let productPriceLabel = UILabel()
    let quantityLabel = UILabel()
    let incrementButton = UIButton()
    let decrementButton = UIButton()
    var onQuantityChanged: ((Int) -> Void)?
    var onRemoveProduct: (() -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        productNameLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(180)
        }
        
        contentView.addSubview(productPriceLabel)
        productPriceLabel.font = .systemFont(ofSize: 13)
        productPriceLabel.textColor = UIColor(red: 0.166, green: 0.349, blue: 0.996, alpha: 1)
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(2)
            make.left.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(26)
        }
        decrementButton.addTarget(self, action: #selector(decrementQuantity), for: .touchUpInside)
        decrementButton.translatesAutoresizingMaskIntoConstraints = false
        decrementButton.setTitle("-", for: .normal)
        decrementButton.setTitleColor(.black, for: .normal)
        decrementButton.backgroundColor = .systemGray6
        contentView.addSubview(decrementButton)
        decrementButton.snp.makeConstraints { make in
            make.left.equalTo(productNameLabel.snp.right).offset(15)
            make.top.equalToSuperview()
            make.width.equalTo(50)

            make.height.equalTo(42)
        }
        contentView.addSubview(quantityLabel)
        quantityLabel.layer.zPosition = 1
        quantityLabel.textColor = .white
        quantityLabel.textAlignment = .center
        quantityLabel.isHidden = false
        quantityLabel.backgroundColor = UIColor(red: 0.166, green: 0.349, blue: 0.996, alpha: 1)
        quantityLabel.snp.makeConstraints { make in
            make.left.equalTo(decrementButton.snp.right)
            make.centerY.equalTo(decrementButton.snp.centerY)
            make.width.equalTo(56)
            make.height.equalTo(42)
        }
        incrementButton.addTarget(self, action: #selector(incrementQuantity), for: .touchUpInside)
        incrementButton.translatesAutoresizingMaskIntoConstraints = false
        incrementButton.setTitle("+", for: .normal)
        incrementButton.setTitleColor(.black, for: .normal)
        incrementButton.backgroundColor = .systemGray6
        contentView.addSubview(incrementButton)
        incrementButton.snp.makeConstraints { make in
            make.left.equalTo(quantityLabel.snp.right)
            make.centerY.equalTo(decrementButton.snp.centerY)
            make.height.equalTo(42)
            make.width.equalTo(50)

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
            if let currentQuantity = Int(quantityLabel.text ?? "0") {
                if currentQuantity > 1 {
                    let newQuantity = currentQuantity - 1
                    quantityLabel.text = "\(newQuantity)"
                    onQuantityChanged?(newQuantity)
                } else {
                    onRemoveProduct?()
                }
            }
        }
    func configure(with item: CartItem) {
        productNameLabel.text = item.productName
        productPriceLabel.text = "\(item.price)₺"
        quantityLabel.text = "\(item.quantity)"
    }}
