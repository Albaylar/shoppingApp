//
//  DetailVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 5.01.2024.
//

import UIKit
import SnapKit
import CoreData
import AlamofireImage


class CarDetailVC: UIViewController {
    var viewModel: CarDetailViewModel?
    var onClose: (() -> Void)?
    // UI Elemanları
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let carImageView = UIImageView()
    private let brandNameLabel = UILabel()
    private var isFavorite = false
    let starView = UIButton()
    
    let topLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkFavoriteStatus()
        setupUI()
        displayCarDetails()
    }
    
    private func setupUI() {
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 0.166, green: 0.349, blue: 0.996, alpha: 1)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = .white
        topView.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.bottom.equalToSuperview().inset(15)
            make.height.equalTo(20)
            make.width.equalTo(21.67)
            
            
        }
        topLabel.textAlignment = .center
        topLabel.textColor = .white
        topLabel.numberOfLines = 0
        topView.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(14)
            make.height.equalTo(22)
            
        }
        
        // carImageView Yapılandırması
        carImageView.contentMode = .scaleToFill
        view.addSubview(carImageView)
        carImageView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(225) // İmajın yüksekliği
        }
        starView.setImage(UIImage(systemName: "star"), for: .normal)
        starView.layer.zPosition = 1
        starView.isUserInteractionEnabled = true
        
        starView.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside) // Add this line
        carImageView.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalTo(carImageView.snp.top).offset(10)
            make.right.equalTo(carImageView.snp.right).inset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        
        
        // nameLabel Yapılandırması
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textAlignment = .left
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(carImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
        }

        // descriptionLabel Yapılandırması
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        
        view.addSubview(priceLabel)
        priceLabel.numberOfLines = 2
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(19)
            make.height.equalTo(44)
            make.width.equalTo(100)
            
        }
        let addToCartButton = UIButton()
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.layer.cornerRadius = 4
        addToCartButton.addTarget(self, action: #selector(addChartButtonTapped), for: .touchUpInside)
        addToCartButton.backgroundColor = UIColor(red: 0.166, green: 0.349, blue: 0.996, alpha: 1)
        addToCartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(addToCartButton)
        addToCartButton.snp.makeConstraints { make in
            make.left.equalTo(priceLabel.snp.right).offset(64)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(22)
            make.height.equalTo(38)
            make.width.equalTo(182)
        }
        
    }
    
    private func displayCarDetails() {
        nameLabel.text = viewModel?.name
        descriptionLabel.text = viewModel?.description
        brandNameLabel.text = viewModel?.brand
        topLabel.text = viewModel?.name
        
        if let imageURL = viewModel?.imageURL {
            carImageView.af.setImage(withURL: imageURL)
        }
        
        if let formattedPrice = viewModel?.formattedPrice {
            // Check if formattedPrice already contains "Price: "
            if formattedPrice.contains("Price: ") {
                priceLabel.text = formattedPrice
            } else {
                // If not, format and display with "Price: " and currency symbol
                let priceText = NSMutableAttributedString(string: "Price: ", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.blue,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
                ])
                
                let priceValue = NSAttributedString(string: "\(formattedPrice) ₺", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.black,
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
                ])
                
                priceText.append(priceValue)
                priceLabel.attributedText = priceText
            }
        }
        
    }
    
    @objc private func addChartButtonTapped(){
        
    }
    @objc private func backButtonTapped() {
        onClose?()
        
    }
    private func checkFavoriteStatus() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let carId = viewModel?.id else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity") // Entity adınızı girin
        fetchRequest.predicate = NSPredicate(format: "id == %@", carId)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            isFavorite = results.count > 0
        } catch let error as NSError {
            print("Favori durumu kontrol edilirken hata oluştu: \(error), \(error.userInfo)")
            isFavorite = false
        }
        
        updateFavoriteIcon()
    }
    
    private func updateFavoriteIcon() {
        let iconName = isFavorite ? "star.fill" : "star"
        starView.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let carId = viewModel?.id else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        isFavorite.toggle()
        
        if isFavorite {
            // Favorilere ekle
            let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)! // Entity adınızı girin
            let newFavorite = NSManagedObject(entity: entity, insertInto: managedContext)
            newFavorite.setValue(carId, forKey: "id")
            // Diğer özellikleri de ayarlayın
        } else {
            // Favorilerden çıkar
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity") // Entity adınızı girin
            fetchRequest.predicate = NSPredicate(format: "id == %@", carId)
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                for object in results {
                    if let objectToDelete = object as? NSManagedObject {
                        managedContext.delete(objectToDelete)
                    }
                }
            } catch let error as NSError {
                print("Favorilerden çıkarırken hata meydana geldi: \(error), \(error.userInfo)")
            }
        }
        
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        } catch let error as NSError {
            print("Favorilere eklerken/kaldırırken hata meydana geldi: \(error), \(error.userInfo)")
        }
        
        updateFavoriteIcon()
    }
    
}

