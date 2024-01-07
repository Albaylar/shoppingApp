//
//  FavoritesVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//
import UIKit

class FavoriteVC: UIViewController {
    
    private let tableView = UITableView()
    private var favviewModel = FavoriteViewModel()
    let noFavoritesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavorites()
    }
    private func setupUI() {
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
        
        noFavoritesLabel.text = "Favorilenmiş ürün yoktur"
        noFavoritesLabel.layer.zPosition = 1
        noFavoritesLabel.textAlignment = .center
        noFavoritesLabel.isHidden = true
        view.addSubview(noFavoritesLabel)
        noFavoritesLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.right.left.bottom.equalToSuperview()
        }
    }
    @objc func favoritesUpdated() {
        updateFavorites()
    }
    
    private func updateFavorites() {
        favviewModel.fetchFavorites()
        tableView.reloadData()
        checkForEmptyFavorites()
    }
    
    private func checkForEmptyFavorites() {
        noFavoritesLabel.isHidden = !favviewModel.favoriteCars.isEmpty
    }
}

extension FavoriteVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favviewModel.favoriteCars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let favoriteCar = favviewModel.favoriteCars[indexPath.row]
        cell.textLabel?.text = "\(favoriteCar.name)"
        cell.textLabel?.font = .boldSystemFont(ofSize: 22)
        cell.textLabel?.textAlignment = .left
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let favoriteCar = favviewModel.favoriteCars[indexPath.row]
            favviewModel.deleteFavoriteCar(withId: favoriteCar.id)
            favviewModel.favoriteCars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        }
    }
}






