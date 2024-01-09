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
    func favoriteButtonTapped(for car: Car, isFavorite: Bool)
    func addToCartButtonTapped(for car: Car)

}

final class HomeCell: UICollectionViewCell {
    weak var delegate: HomeCellDelegate?
    var car: Car?
    let homeViewModel = HomeViewModel()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        
        contentView.addSubview(imageView)
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.9) 
        }
        
        imageView.addSubview(favoriteButton)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .gray
        favoriteButton.layer.zPosition = 1
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.right.equalTo(imageView.snp.right).inset(6)
            make.height.equalTo(24)
        }
       
        contentView.addSubview(priceLabel)
        priceLabel.text = "17.00 $"
        priceLabel.textAlignment = .left
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.text =  "iphone 14 promax"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(addToCartButton)
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.addTarget(self, action: #selector(addChartButtonTapped), for: .touchUpInside)
        addToCartButton.backgroundColor = UIColor(red: 0.166, green: 0.349, blue: 0.996, alpha: 1)
        addToCartButton.layer.cornerRadius = 4
        addToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(36)
        }
    }
    
     func updateFavoriteButtonAppearance() {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            print(isFavorite)
            favoriteButton.tintColor = .systemYellow
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButton.tintColor = .gray
        }
    }
    func configure(with car: Car, isFavorite: Bool) {
        self.car = car
        self.isFavorite = isFavorite

        titleLabel.text = car.name
        priceLabel.text = "\(car.price ?? "") ₺"
        if let imageUrl = car.image, let url = URL(string: imageUrl) {
            imageView.af.setImage(withURL: url)
        }
        updateFavoriteButtonAppearance()
    }

    @objc private func favoriteButtonTapped() {
            isFavorite.toggle()
            DispatchQueue.main.async {
                self.updateFavoriteButtonAppearance()
            }
            if let car = car {
                delegate?.favoriteButtonTapped(for: car, isFavorite: isFavorite)
            }
        }
    @objc func addChartButtonTapped() {
        if let car = car {
            delegate?.addToCartButtonTapped(for: car)
        }
    }
}

