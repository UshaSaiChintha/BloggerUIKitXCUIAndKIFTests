//
//  BloggerUIKitXCUIAndKIFTestsUITests.swift
//  BloggerUIKitXCUIAndKIFTestsUITests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import XCTest

final class BloggerUIKitXCUIAndKIFTestsUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVerifyBlogsNavigationTitle() throws {
        // UI tests must launch the application that they test.
        
        let blogs = app.staticTexts["Blogs"]
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(blogs.exists)
    }
    
    func testVerifyDisplayOfBlogs() throws {
        
        let firstBlogPostTitle = "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"
        let firstBlogPostBody = "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        
        XCTAsyncAssert(app.staticTexts[firstBlogPostTitle])
        XCTAsyncAssert(app.staticTexts.matching(multilineLabel: firstBlogPostBody).element)
    }
    
    func testNavigateToBlogsDetailsScreenAndVerifyLabels() throws {
        
        let firstBlogPostTitle = "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"
        
        app.staticTexts[firstBlogPostTitle].tap()
        
        XCTAsyncAssert(app.buttons["Blogs"])
        XCTAsyncAssert(app.staticTexts["Label"])
    }

    func XCTAsyncAssert(_ element: XCUIElement) {
        let isElementExist = element.waitForExistence(timeout: 2)
        if isElementExist {
            XCTAssertTrue(element.exists)
        }
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

extension XCUIElementQuery {
    func matching(multilineLabel label: String) -> XCUIElementQuery {
        matching(NSPredicate(format: "label == %@", label))
    }
}
