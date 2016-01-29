// ViewController.swift
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

import UIKit
import APESuperHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var messageWithDefaultIconButton: UIButton!
    @IBOutlet weak var messageWithCustomIconButton: UIButton!
    @IBOutlet weak var loadingWithTextButton: UIButton!
    @IBOutlet weak var loadingWithoutTextButton: UIButton!
    @IBOutlet weak var loadingWithFunnyMessagesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Appearnce
        setupHudAppearance()
        
        // Setup Buttons
        setupButtonsLayout()
    }
    
    private func setupHudAppearance() {
        APESuperHUD.appearance.cornerRadius = 12
        APESuperHUD.appearance.animateInTime = 1.0
        APESuperHUD.appearance.animateOutTime = 1.0
        APESuperHUD.appearance.backgroundBlurEffect = .None
        APESuperHUD.appearance.iconColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        APESuperHUD.appearance.textColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        APESuperHUD.appearance.loadingActivityIndicatorColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        APESuperHUD.appearance.defaultDurationTime = 4.0
        APESuperHUD.appearance.cancelableOnTouch = true
        APESuperHUD.appearance.iconWidth = 48
        APESuperHUD.appearance.iconHeight = 48
        APESuperHUD.appearance.fontName = "Caviar Dreams"
        APESuperHUD.appearance.fontSize = 14
    }
    
    private func setupButtonsLayout() {
        loadingWithTextButton.layer.cornerRadius = loadingWithFunnyMessagesButton.frame.height / 2
        loadingWithoutTextButton.layer.cornerRadius = loadingWithoutTextButton.frame.height / 2
        loadingWithFunnyMessagesButton.layer.cornerRadius = loadingWithFunnyMessagesButton.frame.height / 2
        messageWithDefaultIconButton.layer.cornerRadius = messageWithDefaultIconButton.frame.height / 2
        messageWithCustomIconButton.layer.cornerRadius = messageWithCustomIconButton.frame.height / 2
    }
    
    @IBAction func withDefaultIconButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(.Email, message: "1 new message", duration: 3.0, presentingView: self.view, completion: { _ in
            // Completed
        })
    }
    
    @IBAction func withCustomIconButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(UIImage(named: "apegroup")!, message: "Demo message", duration: 3.0, presentingView: self.view, completion: { _ in
            // Completed
        })
    }
    
    @IBAction func withLoadingTextButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(.Standard, message: "Demo loading...", presentingView: self.view, completion: nil)
        
        runWithDelay(3.0, closure: { [weak self] in
            APESuperHUD.showOrUpdateHUD(.CheckMark, message: "Done loading!", duration: 2.0, presentingView: self!.view, completion: nil)
            })
    }
    
    @IBAction func withoutLoadingTextButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(.Standard, message: "", presentingView: self.view, completion: nil)
        
        runWithDelay(3.0, closure: { [weak self] in
            APESuperHUD.removeHUD(animated: true, presentingView: self!.view, completion: nil)
            })
    }
    
    @IBAction func withFunnyLoadingTextButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(.Standard, funnyMessagesLanguage: .English, presentingView: self.view, completion: nil)
        
        runWithDelay(10.0, closure: { [weak self] in
            APESuperHUD.removeHUD(animated: true, presentingView: self!.view, completion: nil)
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    
    func runWithDelay(delay: Double, closure: Void -> Void) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), closure)
    }
}

