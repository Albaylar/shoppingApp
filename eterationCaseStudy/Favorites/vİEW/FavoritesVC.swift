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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        favviewModel.fetchFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: NSNotification.Name("FavoritesUpdated"), object: nil)
        tableView.reloadData()
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
        // TableView ayarları
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // SnapKit ile constraint'leri ayarla
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.right.left.bottom.equalToSuperview()
        }
    }
    @objc func favoritesUpdated() {
        favviewModel.fetchFavorites()
        tableView.reloadData()
    }
    
}

extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favviewModel.favoriteCars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let favoriteCar = favviewModel.favoriteCars[indexPath.row]
        cell.textLabel?.text = "\(favoriteCar.name) - \(favoriteCar.price)"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let favoriteCar = favviewModel.favoriteCars[indexPath.row]
            favviewModel.deleteFavoriteCar(withId: favoriteCar.id)
            
            favviewModel.favoriteCars.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            NotificationCenter.default.post(name: NSNotification.Name("updateWithFavorites"), object: nil)
        }
    }
}






