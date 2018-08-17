import XCTest


class RoutesExampleUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUINavigation() {
        let app = XCUIApplication()
		
		app.buttons["Posts"].tap()
		app.tables.cells.staticTexts["Post 2"].tap()
		XCTAssert(app.staticTexts["Post: 2"].exists)
		app.navigationBars["Post"].buttons["Posts"].tap()
		app.navigationBars["Posts"].buttons["Done"].tap()
		XCTAssert(app.staticTexts["First View"].exists)
    }
	
	func testURLScheme() {
		let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
		safari.launch()

		safari.buttons["URL"].tap()
		safari.typeText("routesexample:///posts\n")
		safari.otherElements["WebView"].buttons["Open"].tap()
		

		let app = XCUIApplication()
		XCTAssert(app.navigationBars["Posts"].buttons["Done"].exists)
	}
}
