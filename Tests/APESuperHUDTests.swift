// APESuperHUDTests.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 apegroup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
import CoreGraphics
@testable import APESuperHUD

class APESuperHUDTests: XCTestCase {
    
    let originalText = "This is a test message"
    let updatedTest = "This is a updated test message"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Appearance tests
    
    func testAppearance() {
        let animationInTime = 1.2
        let animationOutTime = 1.5
        let backgroundColor = UIColor.black
        let cornerRadius = 12.0
        let foregroundColor = UIColor.black
        let iconColor = UIColor.brown
        let loadingActivityIndicatorColor = UIColor.purple
        
        APESuperHUD.appearance.animateInTime = animationInTime
        APESuperHUD.appearance.animateOutTime = animationOutTime
        APESuperHUD.appearance.backgroundColor = backgroundColor
        APESuperHUD.appearance.cornerRadius = cornerRadius
        APESuperHUD.appearance.foregroundColor = foregroundColor
        APESuperHUD.appearance.iconColor = iconColor
        APESuperHUD.appearance.loadingActivityIndicatorColor = loadingActivityIndicatorColor
        
    
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
       
        let hudView = APESuperHUD.createHudViewIfNeeded(presentingView: testView)
        
        XCTAssertEqual(hudView.hudMessageView.layer.cornerRadius, CGFloat(cornerRadius))
        XCTAssertEqual(hudView.hudMessageView.backgroundColor, foregroundColor)
        XCTAssertEqual(hudView.iconImageView.tintColor, iconColor)
        XCTAssertEqual(hudView.loadingActivityIndicator.color, loadingActivityIndicatorColor)
    }
    
    // MARK: - Loading indicator tests
    
    func testLoadingIndicatorWithInfo() {
        let testView = getTestView()
        
        // Test show
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: originalText, presentingView: testView)
        validateShow(view: testView)
        validateLoadIndicator(view: testView, informationText: self.originalText)
        
        // Test update
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: updatedTest, presentingView: testView)
        validateUpdateLoadingIndicator(view: testView, description: "Delay update loading indicator with info")
        
        // Test remove
        self.validateRemove(view: testView, description: "Completion remove loading indicator with info")
    }
    
    func validateUpdateLoadingIndicator(view: UIView, description: String) {
        let asyncExpectation = expectation(description: description)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            self.validateShow(view: view)
            self.validateLoadIndicator(view: view, informationText: self.updatedTest)
            asyncExpectation.fulfill()
            
        })
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while updating HUD")
        }
    }
    
    func testLoadingIndicator() {
        let testView = getTestView()
        
        // Test show
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: testView)
        validateShow(view: testView)
        validateLoadIndicator(view: testView, informationText: "")
        
        // Test remove
        validateRemove(view: testView, description: "Completion remove loading indicator")
    }
    
    func testLoadingIndicatorRandomFunnyMessages() {
        let testView = getTestView()
        
        // Test show
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, funnyMessagesLanguage: .english, presentingView: testView)
        validateShow(view: testView)
        let asyncExpectation = expectation(description: description)
        
        let delayTime = APESuperHUD.appearance.animateOutTime + APESuperHUD.appearance.animateInTime
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: {
            
            let hudView = self.getHudView(view: testView)
            XCTAssertEqual(hudView?.isActiveTimer, true)
            XCTAssertNotEqual(hudView?.informationLabel.text, "")
            XCTAssertEqual(hudView?.loadingActivityIndicator.isHidden, false)
            XCTAssertEqual(hudView?.loadingActivityIndicator.isAnimating, true)
            XCTAssertEqual(hudView?.iconImageView.alpha, 0.0)
            XCTAssertEqual(hudView?.iconImageView.image, nil)
            asyncExpectation.fulfill()
            
        })
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while updating HUD")
        }
        
        // Test remove
        validateRemove(view: testView, description: "Completion remove loading indicator random funny messages")
    }
    
    // MARK: - Message tests
    
    func testMessageWithDefaultIconAndDuration() {
        let testView = getTestView()
        
        // Test show and duration
        APESuperHUD.showOrUpdateHUD(icon: .email, message: originalText, duration: 4.0, presentingView: testView, completion: nil)
        validateShow(view: testView)
        validateMessage(view: testView, informationText: originalText)
        
        let asyncExpectation = expectation(description: "Delay duration message with default icon and duration")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            
            if self.hudViewExists(view: testView) {
                XCTFail("HUD did not get removed.")
            }
            asyncExpectation.fulfill()

        })

        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while updating HUD")
        }
    }
    
    func testMessageWithDefaultIcon() {
        let testView = getTestView()
        
        // Test show
        APESuperHUD.showOrUpdateHUD(icon: .happyFace, message: originalText, presentingView: testView, completion: nil)
        validateShow(view: testView)
        validateMessage(view: testView, informationText: originalText)
        
        // Test update
        APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: updatedTest, presentingView: testView, completion: nil)
        let asyncExpectation = expectation(description: "Delay update message with default icon")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            
            self.validateShow(view: testView)
            self.validateMessage(view: testView, informationText: self.updatedTest)
            asyncExpectation.fulfill()

        })
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while updating HUD")
        }
    }
    
    func testMessageWithDefaultIconDurationAndCompletion() {
        let testView = getTestView()
        
        // Test show and auto remove
        let asyncExpectation = expectation(description: "Completion duration message with default icon, duration and completion")
        APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: originalText, duration: 3.0, presentingView: testView, completion: { _ in
            asyncExpectation.fulfill()
        })
        validateShow(view: testView)
        validateMessage(view: testView, informationText: originalText)
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while removing HUD")
            if self.hudViewExists(view: testView) {
                XCTFail("HUD view did not get removed.")
            }
        }
    }
    
    func testMessageWithImageIcon() {
        let testView = getTestView()
        
        // Test show and auto remove
        APESuperHUD.showOrUpdateHUD(icon: createTestImage(width: 200, height: 200), message: originalText, presentingView: testView, completion: nil)
        validateShow(view: testView)
        validateMessage(view: testView, informationText: originalText)
        
        let asyncExpectation = expectation(description: "Delay duration message with image icon")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + APESuperHUD.appearance.defaultDurationTime + 1, execute: {
            
            if self.hudViewExists(view: testView) {
                XCTFail("HUD did not get removed.")
            }
            asyncExpectation.fulfill()
            
        })
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while updating HUD")
        }
    }
    
    func testMessageWithImageIconAndCompletion() {
        let testView = getTestView()
        
        let asyncExpectation = expectation(description: "Completion duration message with image ccon and completion")
        APESuperHUD.showOrUpdateHUD(icon: createTestImage(width: 200, height: 200), message: originalText, presentingView: testView, completion: { _ in
            asyncExpectation.fulfill()
        })
        validateShow(view: testView)
        validateMessage(view: testView, informationText: originalText)
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while removing HUD")
            if self.hudViewExists(view: testView) {
                XCTFail("HUD view did not get removed.")
            }
        }
    }
    
    func testMessageWithImageIconAndDuration() {
        let testView = getTestView()
        
        APESuperHUD.showOrUpdateHUD(icon: createTestImage(width: 200, height: 200), message: originalText, duration: 3.0, presentingView: testView, completion: nil)
        validateShow(view: testView)
        validateMessage(view: testView, informationText: originalText)
        
        let asyncExpectation = expectation(description: "Delay duration message with image icon and duration")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            
            if self.hudViewExists(view: testView) {
                XCTFail("HUD did not get removed.")
            }
            asyncExpectation.fulfill()
            
        })
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while updating HUD")
        }
    }
    
    func testMessageWithImageIconDurationAndCompletion() {
        let testView = getTestView()
        
        let asyncExpectation = expectation(description: "Completion duration message with image icon, duration and completion")
        APESuperHUD.showOrUpdateHUD(icon: createTestImage(width: 200, height: 200), message: originalText, duration: 3.0, presentingView: testView, completion: { _ in
            asyncExpectation.fulfill()
        })
        validateShow(view: testView)
        validateMessage(view: testView, informationText: originalText)
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while removing HUD")
            if self.hudViewExists(view: testView) {
                XCTFail("HUD view did not get removed.")
            }
        }
    }
    
    // MARK: - Gesture recognize tests
    
    func testTapGestureRecognized() {
        APESuperHUD.appearance.cancelableOnTouch = true
        
        let testView = getTestView()
        
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: originalText, presentingView: testView)
        validateShow(view: testView)
        let hudView = getHudView(view: testView)
        hudView?.tapGestureRecognized(sender: "" as AnyObject)
        
        let asyncExpectation = expectation(description: "Delay tap guesture recognized")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            
            // Validate that hud view is removed
            if self.hudViewExists(view: testView) {
                XCTFail("HUD view did not get removed when tapped.")
            }
            
            asyncExpectation.fulfill()
            
        })
        
        self.waitForExpectations(timeout: 8) { error in
            XCTAssertNil(error, "A error while tap view")
        }
    }
    
    // MARK: - Validations
    
    func validateRemove(view: UIView, description: String) {
        let asyncExpectation = expectation(description: description)
        APESuperHUD.removeHUD(animated: true, presentingView: view, completion: { _ in
            asyncExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 8) { error in
            print(description)
            XCTAssertNil(error, "A error while removing HUD")
            if self.hudViewExists(view: view) {
                XCTFail("HUD view did not get removed.")
            }
        }
    }
    
    func validateLoadIndicator(view: UIView, informationText: String) {
        let hudView = self.getHudView(view: view)
        XCTAssertEqual(hudView?.informationLabel.text, informationText)
        XCTAssertEqual(hudView?.loadingActivityIndicator.isHidden, false)
        XCTAssertEqual(hudView?.loadingActivityIndicator.isAnimating, true)
        XCTAssertEqual(hudView?.iconImageView.alpha, 0.0)
        XCTAssertEqual(hudView?.iconImageView.image, nil)
    }
    
    func validateMessage(view: UIView, informationText: String) {
        let hudView = getHudView(view: view)
        XCTAssertEqual(hudView?.informationLabel.text, informationText)
        XCTAssertEqual(hudView?.loadingActivityIndicator.isAnimating, false)
        XCTAssertEqual(hudView?.iconImageView.alpha, 1.0)
        XCTAssertNotEqual(hudView?.iconImageView.image, nil)
    }
    
    func validateShow(view: UIView) {
        if !hudViewExists(view: view) {
            XCTFail("No HUD view was added to the view.")
        }
    }
    
    // MARK: - Helpers
    
    func hudViewExists(view: UIView) -> Bool {
        var hudViewExists = false
        for subView in view.subviews {
            if subView is HudView {
                hudViewExists = true
            }
        }
        
        return hudViewExists
    }
    
    func getTestView() -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    }
    
    func getHudView(view: UIView) -> HudView? {
        for subView in view.subviews {
            if let hudView = subView as? HudView {
                return hudView
            }
        }
        
        return nil
    }
    
    func createTestImage(width: CGFloat, height: CGFloat, color: UIColor = UIColor.green) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        color.set()
        UIRectFill(rect)
        let testImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return testImage!
    }
}
