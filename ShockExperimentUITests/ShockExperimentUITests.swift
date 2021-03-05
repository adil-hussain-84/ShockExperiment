//
//  ShockExperimentUITests.swift
//  ShockExperimentUITests
//
//  Created by Adil Hussain on 26/02/2021.
//

import XCTest
import Shock

class ShockExperimentUITests: XCTestCase {
    
    private var application: XCUIApplication!
    private var mockServer: MockServer!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        application = XCUIApplication()
        application.launchArguments = ["-mockServer"]
        
        mockServer = MockServer(port: 6789, bundle: Bundle(for: type(of: self)))
        mockServer.shouldSendNotFoundForMissingRoutes = true
        mockServer.start()
    }
    
    override func tearDown() {
        super.tearDown()
        mockServer.stop()
    }
    
    func test_getting_characters_fails_when_route_is_not_setup() {
        // When.
        application.launch()
        
        // Then.
        XCTAssertTrue(application.staticTexts["Failed getting characters."].waitForExistence(timeout: 1))
    }
    
    func test_getting_characters_succeeds_when_simple_route_is_setup() {
        // Given.
        let route: MockHTTPRoute = .simple(
            method: .get,
            urlPath: "people",
            code: 200,
            filename: "simple-response.json"
        )
        
        mockServer.setup(route: route)
        
        // When.
        application.launch()
        
        // Then.
        XCTAssertTrue(application.staticTexts["Got 0 characters."].waitForExistence(timeout: 1))
    }
    
    func test_getting_characters_succeeds_when_template_route_is_setup() {
        // Given.
        let route: MockHTTPRoute = .template(
            method: .get,
            urlPath: "people",
            code: 200,
            filename: "template-response.json",
            templateInfo: ["count": 2]
        )
        
        mockServer.setup(route: route)
        
        // When.
        application.launch()
        
        // Then.
        XCTAssertTrue(application.staticTexts["Got 2 characters."].waitForExistence(timeout: 1))
    }
}
