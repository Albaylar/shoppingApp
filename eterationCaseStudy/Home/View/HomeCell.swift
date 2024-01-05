//
//  HomeCell.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit
import SnapKit
import AlamofireImage


protocol HomeCellDelegate: AnyObject {
    func addToBasketButtonTapped(for car: Car)
}

class HomeCell: UICollectionViewCell {
    weak var delegate: HomeCellDelegate?
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let addToCartButton = UIButton()
    let favoriteButton = UIButton()
    var isFavorite: Bool = false {
        
        didSet {
            updateFavoriteButtonAppearance()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        // ImageView Ayarları
        contentView.addSubview(imageView)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(150)
        }
        imageView.addSubview(favoriteButton)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .gray
        favoriteButton.layer.zPosition = 1
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        // Price Label Ayarları
        contentView.addSubview(priceLabel)
        priceLabel.text = "17.00 $"
        priceLabel.textAlignment = .left
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        // Title Label Ayarları
        contentView.addSubview(titleLabel)
        titleLabel.text =  "iphone 14 promax"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        // Add to Cart Button Ayarları
        contentView.addSubview(addToCartButton)
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.addTarget(self, action: #selector(addChartButtonTapped), for: .touchUpInside)
        addToCartButton.backgroundColor = UIColor.blue
        addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(36)
        }
    }
    
    private func updateFavoriteButtonAppearance() {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButton.tintColor = .yellow // Favori ise sarı renk
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteButton.tintColor = .gray // Değilse gri renk
        }
    }
    func configure(with car: Car) {
        priceLabel.text = "\(car.price ?? "") ₺"
        titleLabel.text = car.name ?? ""
        if let imageUrl = car.image, let url = URL(string: imageUrl) {
            imageView.af.setImage(withURL: url)
        }
    }
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        DispatchQueue.main.async {
            self.updateFavoriteButtonAppearance()
        }
    }
    @objc func addChartButtonTapped() {
//           if let car = car { // Assume you have a car property in your HomeCell
//               delegate?.addToBasketButtonTapped(for: car)
//           }
       }
}

