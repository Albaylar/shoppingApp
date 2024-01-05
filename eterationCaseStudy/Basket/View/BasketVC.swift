//
//  BasketVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit
import SnapKit

class BasketVC: UIViewController {

    var basketItems: [CartItem] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func addToBasket(car: Car) {
            guard let priceString = car.price,
                  let price = Double(priceString) else {
                print("Fiyat dönüştürülemedi")
                return
            }
            let cartItem = CartItem(productId: car.id ?? "",
                                    productName: car.name ?? "",
                                    quantity: 1,
                                    price: price)
            self.basketItems.append(cartItem)
            tableView.reloadData() // Sepete ekleme yapıldıktan sonra tableView güncellenmeli
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
            make.right.left.equalToSuperview().inset(15)
            
        }
        
    }
}
extension BasketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! BasketCell
                let cartItem = basketItems[indexPath.row]
                cell.configure(with: cartItem) // Car yerine CartItem geçirilmeli

                return cell
            }
}
