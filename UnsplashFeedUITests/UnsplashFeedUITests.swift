//
//  UnsplashFeedUITests.swift
//  UnsplashFeedUITests
//
//  Created by Avtor_103 on 06.10.2023.
//

import XCTest

final class UnsplashFeedUITests: XCTestCase {

    private var app: XCUIApplication?
        
    override func setUpWithError() throws {
        try super.setUpWithError()
            
        app = XCUIApplication()
        app?.launch()
            
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app?.terminate()
        app = nil
    }
        
    func testAuth() throws {
        guard let app else {
            XCTFail("Application does not exist")
            return
        }
        
        sleep(5)
        
        app.buttons["Authenticate"].tap()
        
        sleep(5)
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
                
        loginTextField.tap()
        loginTextField.typeText("")
        webView.tap()
                
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
                
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
                
        webView.buttons["Login"].tap()
                
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
                
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
        
    func testFeed() throws {
        guard let app else {
            XCTFail("Application does not exist")
            return
        }
        
        sleep(10)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(5)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["FavotiteButton"].tap()
        
        sleep(5)
        
        cellToLike.buttons["FavotiteButton"].tap()
        
        sleep(5)
    
        cellToLike.tap()
        
        sleep(5)
 
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
   
        image.pinch(withScale: 3, velocity: 1)
    
        image.pinch(withScale: 0.5, velocity: -1)

        app.buttons["BackButton"].tap()
    }
        
    func testProfile() throws {
        guard let app else {
            XCTFail("Application does not exist")
            return
        }
        
        sleep(10)
    
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(5)
        
        XCTAssertTrue(app.staticTexts["@theabcdengineer"].exists)
        XCTAssertTrue(app.staticTexts["Hello Mr. Reviewer"].exists)
        XCTAssertTrue(app.buttons["LogoutButton"].exists)
  
        app.buttons["LogoutButton"].tap()
        
        sleep(5)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(5)

        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
