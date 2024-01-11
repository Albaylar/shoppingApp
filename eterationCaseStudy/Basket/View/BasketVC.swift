//
//  BasketVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit
import SnapKit
import CoreData

final class BasketVC: UIViewController {
    var basketItems: [CartItem] = []
    private let tableView = UITableView()
    private let totalPriceLabel = UILabel()
    private let emptyBasketLabel = UILabel()
    private let viewModel = BasketViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(loadBasketItems), name: NSNotification.Name("BasketUpdated"), object: nil)
        setupEmptyBasketLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadBasketItems()
        updateTotalPriceAndQuantity()
        
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
        tableView.allowsSelection = false
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
    private func setupEmptyBasketLabel() {
        emptyBasketLabel.text = "Sepetinizde ürün bulunmamaktadır"
        emptyBasketLabel.textAlignment = .center
        emptyBasketLabel.isHidden = true
        emptyBasketLabel.layer.zPosition = 1
        view.addSubview(emptyBasketLabel)
        emptyBasketLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    @objc func loadBasketItems() {
        viewModel.loadBasketItems()
        tableView.reloadData()
        updateTotalPriceAndQuantity()
        updateEmptyBasketLabelVisibility()
    }
    
    private func updateEmptyBasketLabelVisibility() {
        emptyBasketLabel.isHidden = !viewModel.basketItems.isEmpty
    }

    
    func updateTotalPriceAndQuantity() {
        let totalPrice = viewModel.totalPrice
        let attributedString = NSMutableAttributedString(
            string: "Price: ",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                         NSAttributedString.Key.foregroundColor: UIColor.blue]
        )
        
        let priceString = NSAttributedString(
            string: "\(totalPrice)₺",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                         NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        attributedString.append(priceString)
        totalPriceLabel.attributedText = attributedString
    }

}
extension BasketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? BasketCell else {
            return UITableViewCell()
        }
        
        let cartItem = viewModel.basketItems[indexPath.row]
        cell.configure(with: cartItem)
        
        cell.onQuantityChanged = { [weak self] newQuantity in
            self?.viewModel.updateQuantity(atIndex: indexPath.row, newQuantity: newQuantity)
            self?.updateTotalPriceAndQuantity()
        }
        cell.onRemoveProduct = { [weak self] in
            self?.viewModel.removeProductFromBasket(atIndex: indexPath.row)
            self?.loadBasketItems()
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

