//
//  RoutesExampleTests.swift
//  RoutesExampleTests
//
//  Created by David Beck on 8/17/18.
//  Copyright © 2018 David Beck. All rights reserved.
//

import XCTest
@testable import RoutesExample


class RouterTests: XCTestCase {
	var router: Router<String>!
	
	override func setUp() {
		super.setUp()
		
		router = Router<String>()
		router.register("/", destination: "Root")
		router.register("/posts", destination: "Post index")
		router.register("/posts/abc", destination: "Post detail constant")
		router.register("/posts/:postID", destination: "Post detail")
		router.register("/posts/:postID", destination: "Post detail alternative")
	}
	
	override func tearDown() {
		router = nil
		
		super.tearDown()
	}
	
	
	// Tests
	
	func testReturnsMatchedParameters() {
		guard let match = router.match(for: URL(string: "myapp:///posts/123")!) else { XCTFail(); return }
		
		XCTAssertEqual(match.destination, "Post detail")
		XCTAssertEqual(match.parameters["postID"], "123")
    }
	
	func testRootRoute() {
		guard let match = router.match(for: URL(string: "myapp:///")!) else { XCTFail(); return }
		
		XCTAssertEqual(match.destination, "Root")
		XCTAssertEqual(match.parameters, [:])
	}
	
	func testUsesFirstRoute() {
		guard let match = router.match(for: URL(string: "myapp:///posts/abc")!) else { XCTFail(); return }
		
		XCTAssertEqual(match.destination, "Post detail constant")
		XCTAssertEqual(match.parameters, [:])
	}
}
