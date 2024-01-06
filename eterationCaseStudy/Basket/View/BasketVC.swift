//
//  BasketVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit
import SnapKit
import CoreData

class BasketVC: UIViewController {
    var basketItems: [CartItem] = []
    let tableView = UITableView()
    let totalPriceLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(loadBasketItems), name: NSNotification.Name("BasketUpdated"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        loadBasketItems()
    }
    
    func addToBasket(car: Car) {
        guard let priceString = car.price, let price = Double(priceString) else {
            print("Fiyat dönüştürülemedi")
            return
        }

        if let index = basketItems.firstIndex(where: { $0.productId == car.id }) {
            // Eğer ürün zaten sepetteyse, miktarını artır
            basketItems[index].quantity += 1
        } else {
            // Eğer ürün sepette değilse, yeni ürün ekle
            let cartItem = CartItem(productId: car.id ?? "", productName: car.name ?? "", quantity: 1, price: price)
            basketItems.append(cartItem)
        }

        tableView.reloadData()
        updateTotalPriceAndQuantity()  // Toplam fiyatı güncelle
    }

    
    func setupUI() {
        view.backgroundColor = .white
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 0.16, green: 0.35, blue: 1.00, alpha: 1.00)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        let label = UILabel()
        label.text = "E-Market"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor =  .white
        topView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.top).offset(6)
            make.left.equalTo(topView.snp.left).inset(16)
            make.bottom.equalTo(topView.snp.bottom).inset(14)
        }
        tableView.register(BasketCell.self, forCellReuseIdentifier: "customCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(17)
            make.right.left.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(140)
            
        }
        
        view.addSubview(totalPriceLabel)
        totalPriceLabel.numberOfLines = 2
        totalPriceLabel.isHidden = false
        totalPriceLabel.font = UIFont.systemFont(ofSize: 18)
        totalPriceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(19)
            make.height.equalTo(44)
            make.width.equalTo(113)
            
        }
        let completeButton = UIButton()
        completeButton.setTitle("Complete", for: .normal)
        completeButton.layer.cornerRadius = 4
        completeButton.backgroundColor = UIColor(red: 0.166, green: 0.349, blue: 0.996, alpha: 1)
        completeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.left.equalTo(totalPriceLabel.snp.right).offset(64)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(22)
            make.height.equalTo(38)
            make.width.equalTo(182)
        }
    }
    
    @objc func loadBasketItems() {
        basketItems = CoreDataManager.shared.fetchBasketItems().map { CartItem(productId: $0.id ?? "", productName: $0.name ?? "", quantity: 1, price: Double($0.price ?? "") ?? 0.0) }
        tableView.reloadData()
    }
    func updateTotalPriceAndQuantity() {
        var totalPrice = 0.0
        
        for item in basketItems {
            totalPrice += item.price * Double(item.quantity)
        }
        
        // Attributed String kullanarak "Total:" kısmını mavi renk ve normal fontla, fiyat kısmını ise bold fontla göster
        let attributedString = NSMutableAttributedString(
            string: "Total: ",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor: UIColor.blue
            ]
        )

        let priceString = NSAttributedString(
            string: "\(totalPrice)₺",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )

        attributedString.append(priceString)
        totalPriceLabel.attributedText = attributedString

        // Post notification with the updated count
        NotificationCenter.default.post(name: .BasketItemCountUpdated, object: nil, userInfo: ["basketItemCount": basketItems.count])
    }


    
}
extension BasketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? BasketCell else {
            return UITableViewCell()
        }
        
        let cartItem = basketItems[indexPath.row]
        cell.configure(with: cartItem)
        // Miktar değiştiğinde tetiklenecek callback
        cell.onQuantityChanged = { [weak self] newQuantity in
            self?.basketItems[indexPath.row].quantity = newQuantity
            // Burada sepetin toplam fiyatını ve miktarını güncelleyebilirsiniz.
            self?.updateTotalPriceAndQuantity()
        }
        
        cell.onRemoveProduct = { [weak self] in
            guard let strongSelf = self else { return }
            
            let productId = strongSelf.basketItems[indexPath.row].productId
            strongSelf.basketItems.remove(at: indexPath.row)
            strongSelf.tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.shared.removeCarFromCart(id: productId)
            NotificationCenter.default.post(name: NSNotification.Name("BasketUpdated"), object: nil)

            // Toplam fiyatı güncelle
            strongSelf.updateTotalPriceAndQuantity()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension Notification.Name {
    static let BasketItemCountUpdated = Notification.Name("BasketItemCountUpdated")
}
