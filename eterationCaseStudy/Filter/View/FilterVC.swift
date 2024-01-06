//
//  FilterVC.swift
//  eterationCaseStudy
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import UIKit
import SnapKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(brand: String?, model: String?,sortOption: SortOption?)
}

final class FilterVC: UIViewController {
    
    private let sortByLabel = UILabel()
    private let brandsSearchBar = UISearchBar()
    private let modelsSearchBar = UISearchBar()
    private let applyButton = UIButton()
    let sortOptions = ["Old to new", "New to old", "Price high to low", "Price low to high"]
    private var brandButtons = [UIButton]()
    private var modelButtons = [UIButton]()
    private let viewModel = FilterViewModel()
    let modelsStackView = UIStackView()
    let brandsStackView = UIStackView()
    var sortButtons = [UIButton]()
    weak var delegate: FilterViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        brandsSearchBar.delegate = self
        modelsSearchBar.delegate = self
        viewModel.loadFilterOptions {
            DispatchQueue.main.async {
                self.updateUIWithFilters()
            }
        }
        
    }
    private func setupUI(){
        view.backgroundColor = .white
        // Close Button Image
        let closeImage = UIImageView()
        closeImage.image = UIImage(named: "closeButton")
        closeImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        closeImage.addGestureRecognizer(tapGesture)
        
        view.addSubview(closeImage)
        closeImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            make.left.equalToSuperview().inset(23)
            make.height.width.equalTo(20)
        }
        // Top Label
        let topLabel = UILabel()
        topLabel.text = "Filter"
        topLabel.font = UIFont.montserratBold(size: 20)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .black
        lineView.layer.shadowColor = UIColor.black.cgColor
        lineView.layer.shadowOffset = CGSize(width: 0, height: 1)
        lineView.layer.shadowOpacity = 1
        lineView.layer.shadowRadius = 4
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(closeImage.snp.bottom).offset(24)
            make.right.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        sortByLabel.text = "Sort By"
        sortByLabel.font = .montserratRegular(size: 12)
        view.addSubview(sortByLabel)
        sortByLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(17.57)
            make.height.equalTo(15)
        }
        
        let sortByStackView = UIStackView()
        sortByStackView.axis = .vertical
        sortByStackView.distribution = .fillEqually
        sortByStackView.alignment = .fill
        sortByStackView.spacing = 15
        view.addSubview(sortByStackView)
        sortByStackView.snp.makeConstraints { make in
            make.top.equalTo(sortByLabel.snp.bottom).offset(21)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(28)
        }
        for option in sortOptions {
            let button = createRadioButtonWithTitle(option)
            sortButtons.append(button)
            sortByStackView.addArrangedSubview(button)
        }
        let lineView2 = UIView()
        lineView2.backgroundColor = .black
        view.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(sortByStackView.snp.bottom).offset(35)
            make.right.left.equalToSuperview().inset(15)
            make.height.equalTo(1.5)
        }
        
        let brandNameLabel = UILabel()
        brandNameLabel.text = "Brand"
        brandNameLabel.font = .systemFont(ofSize: 16)
        view.addSubview(brandNameLabel)
        brandNameLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(18)
            make.height.equalTo(15)
        }
        brandsSearchBar.placeholder = "Search Brand"
        brandsSearchBar.backgroundImage = UIImage()
        view.addSubview(brandsSearchBar)
        brandsSearchBar.snp.makeConstraints { make in
            make.top.equalTo(brandNameLabel.snp.bottom).offset(24.05)
            make.right.left.equalToSuperview().inset(36)
            make.height.equalTo(40)
        }
        let brandsScrollView = UIScrollView()
        view.addSubview(brandsScrollView)
        brandsScrollView.snp.makeConstraints { make in
            make.top.equalTo(brandsSearchBar.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(95)
        }
        brandsStackView.axis = .vertical
        brandsStackView.alignment = .fill
        brandsStackView.distribution = .fillEqually
        brandsStackView.spacing = 15
        brandsScrollView.addSubview(brandsStackView)
        brandsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(brandsScrollView)
        }
        
        let lineView3 = UIView()
        lineView3.backgroundColor = .black
        view.addSubview(lineView3)
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(brandsScrollView.snp.bottom).offset(31)
            make.right.left.equalToSuperview().inset(15)
            make.height.equalTo(1.5)
        }
        let modelNameLabel = UILabel()
        modelNameLabel.text = "Model"
        modelNameLabel.font = .systemFont(ofSize: 16)
        view.addSubview(modelNameLabel)
        modelNameLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView3.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(17.57)
            make.height.equalTo(15)
        }
        
        modelsSearchBar.placeholder = "Search Model"
        modelsSearchBar.backgroundImage = UIImage()
        view.addSubview(modelsSearchBar)
        modelsSearchBar.snp.makeConstraints { make in
            make.top.equalTo(modelNameLabel.snp.bottom).offset(24) 
            make.right.left.equalToSuperview().inset(36)
            make.height.equalTo(40)
        }
        
        let modelsScrollView = UIScrollView()
        view.addSubview(modelsScrollView)
        modelsScrollView.snp.makeConstraints { make in
            make.top.equalTo(modelsSearchBar.snp.bottom).offset(23)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(95)
        }
        modelsStackView.axis = .vertical
        modelsStackView.alignment = .fill
        modelsStackView.distribution = .fillEqually
        modelsStackView.spacing = 15
        modelsScrollView.addSubview(modelsStackView)
        
        modelsStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(modelsScrollView)
        }
        applyButton.setTitle("Primary", for: .normal)
        applyButton.backgroundColor = UIColor(red: 0.166, green: 0.349, blue: 0.996, alpha: 1)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        view.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(modelsScrollView.snp.bottom).offset(20) // Models ScrollView altında
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(38)
        }
    }
    private func createRadioButtonWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal) // Renkleri ayarlayın
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: button.frame.width - button.titleLabel!.frame.width - button.imageView!.frame.width - 9)
        return button
    }
    @objc private func radioButtonTapped(_ sender: UIButton) {
        for button in sortButtons {
            button.isSelected = false
        }
        
        sender.isSelected = true
    }
    private func createCheckboxButtonWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: button.frame.width - button.titleLabel!.frame.width - button.imageView!.frame.width - 9)
        return button
    }
    @objc private func checkboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
    }
    
    @objc private func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func applyButtonTapped() {
        let selectedBrand = brandButtons.first(where: { $0.isSelected })?.title(for: .normal)
        let selectedModel = modelButtons.first(where: { $0.isSelected })?.title(for: .normal)
        let selectedSortOption = sortButtons.enumerated().first(where: { $1.isSelected })?.offset
        var sortOption: SortOption?
        if let selectedSortOption = selectedSortOption {
            switch selectedSortOption {
            case 0:
                sortOption = .dateAscending
            case 1:
                sortOption = .dateDescending
            case 2:
                sortOption = .priceDescending
            case 3:
                sortOption = .priceAscending
            default:
                break
            }
        }
        delegate?.didApplyFilters(brand: selectedBrand, model: selectedModel, sortOption: sortOption)
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func sortOptionTapped(_ sender: UIButton) {
        sortButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
    }
    private func updateUIWithFilters() {
        updateBrandButtons(with: viewModel.brands)
        print(viewModel.brands)
        updateModelButtons(with: viewModel.models)
        print(viewModel.models)
    }
}
extension FilterVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == brandsSearchBar {
            let filteredBrands = viewModel.filterBrands(with: searchText)
            updateBrandButtons(with: filteredBrands)
        } else if searchBar == modelsSearchBar {
            let filteredModels = viewModel.filterModels(with: searchText)
            updateModelButtons(with: filteredModels)
        }
    }
    
    private func updateBrandButtons(with brands: [String]) {
        brandButtons.forEach { $0.removeFromSuperview() }
        brandButtons.removeAll()
        
        for brand in brands {
            let button = createCheckboxButtonWithTitle(brand)
            brandButtons.append(button)
            brandsStackView.addArrangedSubview(button)
        }
    }
    private func updateModelButtons(with models: [String]) {
        modelButtons.forEach { $0.removeFromSuperview() }
        modelButtons.removeAll()
        
        for model in models {
            let button = createCheckboxButtonWithTitle(model)
            modelButtons.append(button)
            modelsStackView.addArrangedSubview(button)
        }
    }
    
}


