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

        // Ürün detay sayfasına gidiliyor
        let productDetailButton = app.buttons["starView"] // Daha açıklayıcı bir isimlendirme kullanılabilir
        XCTAssertTrue(productDetailButton.exists, "Ürün detay butonu mevcut değil.")
        productDetailButton.tap()
        
        // "Sepete Ekle" butonuna tıklanıyor
        let addToCartButton = app.buttons["addToCartButton"]
        XCTAssertTrue(addToCartButton.exists, "Sepete Ekle butonu mevcut değil.")
        addToCartButton.tap()
        
        // Sepete eklenen ürünün kontrolü (örnek olarak)
        // Burada 'sepetOnayMesaji' gibi bir elementin varlığını kontrol edebilirsiniz.
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
