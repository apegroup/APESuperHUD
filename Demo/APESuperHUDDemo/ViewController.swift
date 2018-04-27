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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Appearnce
        setupHudAppearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupHudAppearance() {
        
        APESuperHUD.appearance.cornerRadius = 12
        APESuperHUD.appearance.animateInTime = 1.0
        APESuperHUD.appearance.animateOutTime = 1.0
        APESuperHUD.appearance.iconColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        APESuperHUD.appearance.textColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        APESuperHUD.appearance.loadingActivityIndicatorColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        APESuperHUD.appearance.defaultDurationTime = 4.0
        APESuperHUD.appearance.cancelableOnTouch = true
        APESuperHUD.appearance.iconWidth = 48
        APESuperHUD.appearance.iconHeight = 48
        APESuperHUD.appearance.messageFontName = "Caviar Dreams"
        APESuperHUD.appearance.titleFontName = "Caviar Dreams"
        APESuperHUD.appearance.titleFontSize = 22
        APESuperHUD.appearance.messageFontSize = 14
        APESuperHUD.appearance.backgroundColor = UIColor.white
        APESuperHUD.appearance.particleEffectBackgroundColor = UIColor(red: 0, green: 128.0 / 255.0, blue: 1.0, alpha: 0.85)
        APESuperHUD.appearance.backgroundBlurEffect = .light
    }
    
    @IBAction func showHudWithIconClickToDismissButtonPressed(sender: UIButton) {
        
        let image = UIImage(named: "apegroup")!
        APESuperHUD_new.show(style: .icon(image: image, duration: nil), title: nil, message: "Click to dismiss")
        
        
    }
    
    @IBAction func showHudWithIconAutoDismissButtonPressed(sender: UIButton) {
        
        let image = UIImage(named: "apegroup")!
        APESuperHUD_new.show(style: .icon(image: image, duration: 3.0), title: nil, message: "Auto dismiss after 3 seconds")
        
    }
    
    @IBAction func showHudWithLoadingIndicatorAndTextButtonPressed(sender: UIButton) {
        let hud = APESuperHUD_new(style: .loadingIndicator(type: .standard), title: "test", message: "tsa")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            hud.dismiss(animated: true, completion: {
                print("test")
            })
        })
        present(hud, animated: true, completion: nil)
//
//        let image = UIImage(named: "apegroup")!
//        APESuperHUD_new.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//            APESuperHUD_new.show(style: .icon(image: image, duration: 3.0), title: nil, message: "Done loading!")
//        })
    }
    
    @IBAction func showHudWithOnlyLoadingIndicatorButtonPressed(sender: UIButton) {
        
        let image = UIImage(named: "apegroup")!
        APESuperHUD_new.show(style: .loadingIndicator(type: .standard), title: nil, message: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            APESuperHUD_new.show(style: .icon(image: image, duration: 2.0), title: nil, message: "Done loading!")
        })
    }
    
    @IBAction func showHudWithTitlaAndMessageButtonPressed(sender: UIButton) {
        
        APESuperHUD_new.show(style: .textOnly, title: "Title", message: "Click to dismiss")
        
    }
    
    
    @IBAction func withTitleButtonPressed(sender: UIButton) {
        
        APESuperHUD_new.show(style: .textOnly, title: "Title", message: "Message")
        
    }
    
}

