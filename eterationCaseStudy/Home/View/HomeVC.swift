//
//  HomeVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemsPerRow: CGFloat = 4
            let padding: CGFloat = 5
            let totalPadding: CGFloat = padding * (itemsPerRow - 1)
            let individualItemWidth: CGFloat = (collectionView.bounds.width - totalPadding) / itemsPerRow

            layout.itemSize = CGSize(width: individualItemWidth, height: individualItemWidth)
            layout.minimumLineSpacing = padding
            layout.minimumInteritemSpacing = padding
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
       

        
    }
    @objc func selectFilterButtonTapped(){
        
    }
}
extension HomeVC : UISearchBarDelegate {
    
}
extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

