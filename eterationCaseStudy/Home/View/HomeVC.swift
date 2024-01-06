//
//  HomeVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit
import SnapKit
import CoreData


class HomeVC: UIViewController {
    private let debouncer = Debouncer(delay: 0)
    private var viewModel = HomeViewModel()
    private let favoritesViewModel = FavoriteViewModel()
    private let basketVC = BasketVC()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var containerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadAllCars() {
            self.collectionView.reloadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteStatusChanged(_:)), name: NSNotification.Name("FavoritesUpdatedAgain"), object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func setupUI(){
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
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(15)
        }
        let filterLabel = UILabel()
        filterLabel.text = "Filters:"
        filterLabel.textColor = .black
        filterLabel.font = .systemFont(ofSize: 18)
        view.addSubview(filterLabel)
        filterLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(19)
            make.left.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        let selectFilterButton = UIButton()
        selectFilterButton.setTitle("Select Filter", for: .normal)
        selectFilterButton.backgroundColor = .lightGray
        selectFilterButton.setTitleColor(.black, for: .normal)
        selectFilterButton.addTarget(self, action: #selector(selectFilterButtonTapped), for: .touchUpInside)
        view.addSubview(selectFilterButton)
        selectFilterButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(14)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(17)
            make.left.equalTo(filterLabel.snp.right).offset(138)
            make.height.equalTo(36)
        }
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "HomeCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(selectFilterButton.snp.bottom).offset(24)
            make.right.left.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide) // Alt constraint eklendi
        }
        
    }
    private func configureCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let itemsPerRow: CGFloat = 2
        let padding: CGFloat = 21
        let totalPadding: CGFloat = padding * (itemsPerRow - 1)
        let individualItemWidth: CGFloat = max((collectionView.bounds.width - totalPadding) / itemsPerRow, 0)
        let individualItemHeight: CGFloat = individualItemWidth * 1.66 // Örneğin, genişliğin 1.5 katı
        layout.itemSize = CGSize(width: individualItemWidth, height: individualItemHeight)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
    }
    
    @objc func selectFilterButtonTapped() {
        let filterVC = FilterVC()
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .fullScreen
        present(filterVC, animated: true)
    }
}
extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            viewModel.performSearch(with: query) {
                self.collectionView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.performSearch(with: searchText) {
            self.collectionView.reloadData()
        }
    }
}

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else {
            return UICollectionViewCell()
        }
        let car = viewModel.cars[indexPath.row]
        
        // Favori durumunu kontrol et
        let isFavorite = favoritesViewModel.isCarFavorite(carId: car.id ?? "")
        
        cell.delegate = self
        cell.configure(with: car, isFavorite: isFavorite)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCar = viewModel.cars[indexPath.row]
        let detailVC = CarDetailVC()
        let carDetailViewModel = CarDetailViewModel(car: selectedCar)
        detailVC.viewModel = carDetailViewModel
        // containerView ve detay görünümünü oluştur
        containerView = UIView(frame: self.view.bounds)
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        guard let containerView = containerView else { return }
        self.view.addSubview(containerView)
        // CarDetailVC görünümünü containerView'a ekle
        addChild(detailVC)
        containerView.addSubview(detailVC.view)
        detailVC.view.frame = containerView.bounds
        detailVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailVC.didMove(toParent: self)
        
        // Geri dönüş işlemi için bir closure veya delegate tanımla
        detailVC.onClose = { [weak self] in
            containerView.removeFromSuperview()
            detailVC.view.removeFromSuperview()
            detailVC.removeFromParent()
        }
        
    }
    @objc func favoriteUpdate() {
        // Favoriler listesini yeniden yükleyin
        favoritesViewModel.fetchFavorites()
        // collectionView'u yenileyin
        collectionView.reloadData()
    }
    @objc private func favoriteStatusChanged(_ notification: Notification) {
        guard let updatedCarId = notification.userInfo?["carId"] as? String else { return }

        // Bul ve güncelle
        for (index, car) in viewModel.cars.enumerated() {
            if car.id == updatedCarId {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = collectionView.cellForItem(at: indexPath) as? HomeCell {
                    cell.isFavorite = CoreDataManager.shared.isCarSaved(id: Int(updatedCarId) ?? 0)
                }
            }
        }
    }

    
    
}
extension HomeVC: FilterViewControllerDelegate {
    func didApplyFilters(brand: String?, model: String?, sortOption: SortOption?) {
        viewModel.filterCars(brand: brand, model: model, sortOption: sortOption)
        
        print("Filtrelenmiş araç sayısı: \(viewModel.cars.count)")
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
extension HomeVC: HomeCellDelegate {
    func addToCartButtonTapped(for car: Car) {
        // Assuming 'saveCarToCart' is a method you will implement in CoreDataManager
        CoreDataManager.shared.saveCarToCart(data: car)
        print("Car added to cart")
        NotificationCenter.default.post(name: NSNotification.Name("BasketUpdated"), object: nil)
    }
    
    func favoriteButtonTapped(for car: Car, isFavorite: Bool) {
        if isFavorite {
            CoreDataManager.shared.saveCarsToCoreData(data: car)
            print("Car added to favorites")
        } else {
            if let id = Int(car.id!) { // Convert to Int, handle non-convertible cases
                CoreDataManager.shared.removeCarItemFromCoreData(id: id)
                print("Car removed from favorites")
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
}













