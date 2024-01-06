//
//  eterationCaseStudyUITests.swift
//  eterationCaseStudyUITests
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import XCTest

final class eterationCaseStudyUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testAddToCart() throws {
        let app = XCUIApplication()
        app.launch()
        

    }
    func testHomePageLoadsCorrectly() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.exists, "Arama çubuğu bulunamadı.")
        
        let collectionView = app.collectionViews["ProductCollectionView"]
        XCTAssertTrue(collectionView.exists, "Ürün koleksiyon görünümü bulunamadı.")
    }

    func testProductSearch() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["Search"]
        searchBar.tap()
        searchBar.typeText("Lambo")
        
        // Arama sonuçlarının gösterildiğini kontrol et
        let firstProduct = app.staticTexts["Lamborghini Model S"]
        XCTAssertTrue(firstProduct.waitForExistence(timeout: 5), "Arama sonuçları doğru şekilde görüntülenmiyor.")
    }

    func testProductDetailPage() {
        let app = XCUIApplication()
        app.launch()

        let firstProduct = app.collectionViews.cells.element(boundBy: 0)
        firstProduct.tap()

        let productDetailTitle = app.staticTexts["Bentley Focus"]
        XCTAssertTrue(productDetailTitle.exists, "Ürün detay sayfası doğru şekilde yüklenmedi.")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
