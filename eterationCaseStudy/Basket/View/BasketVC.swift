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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadBasketItems()
        NotificationCenter.default.addObserver(self, selector: #selector(loadBasketItems), name: NSNotification.Name("BasketUpdated"), object: nil)
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
    }
    
    func addToBasket(car: Car) {
        guard let priceString = car.price, let price = Double(priceString) else {
            print("Fiyat dönüştürülemedi")
            return
        }
        if let index = basketItems.firstIndex(where: { $0.productId == car.id }) {
            // Increase quantity if already exists
            basketItems[index].quantity += 1
        } else {
            // Add new item
            let cartItem = CartItem(productId: car.id ?? "", productName: car.name ?? "", quantity: 1, price: price )
            self.basketItems.append(cartItem)
        }
        
        tableView.reloadData()
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(17)
            make.right.left.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(140)
            
        }
    }

    @objc func loadBasketItems() {
        basketItems = CoreDataManager.shared.fetchBasketItems().map { CartItem(productId: $0.id ?? "", productName: $0.name ?? "", quantity: 1, price: Double($0.price ?? "") ?? 0.0) }
        tableView.reloadData()
    }
    func updateTotalPriceAndQuantity() {
            var totalQuantity = 0
            var totalPrice = 0.0

            for item in basketItems {
                totalQuantity += item.quantity
                totalPrice += item.price * Double(item.quantity)
            }

            // Bu örnekte, varsayalım ki toplam fiyat ve miktarı göstermek için iki labelınız var.
//            totalQuantityLabel.text = "Toplam Miktar: \(totalQuantity)"
//            totalPriceLabel.text = "Toplam Fiyat: \(totalPrice)₺"
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
            
            return cell
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 
    }
    
}
