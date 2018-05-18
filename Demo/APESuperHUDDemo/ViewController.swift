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
    
    private func setupHudAppearance() {
        HUDAppearance.cornerRadius = 12
        HUDAppearance.animateInTime = 1.0
        HUDAppearance.animateOutTime = 1.0
        HUDAppearance.iconColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        HUDAppearance.titleTextColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        HUDAppearance.messageTextColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        HUDAppearance.loadingActivityIndicatorColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        HUDAppearance.cancelableOnTouch = true
        HUDAppearance.iconSize = CGSize(width: 40, height: 40)
        HUDAppearance.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        if let messageFont = UIFont(name: "Caviar Dreams", size: 14) {
            HUDAppearance.messageFont = messageFont
        }
        
        if let titleFont = UIFont(name: "Caviar Dreams", size: 22) {
            HUDAppearance.titleFont = titleFont
        }
    }
    
    @IBAction func showHudWithIcon(_ sender: UIButton) {
        let image = UIImage(named: "apegroup")!
        APESuperHUD.show(style: .icon(image: image, duration: 3.0), title: "Hello", message: "world")
        
        // Or create a instance of APESuperHud
        
        /*
        let hudViewController = APESuperHUD(style: .icon(image: image, duration: 3), title: "Hello", message: "world")
        present(hudViewController, animated: true)
        */
    }
    
    @IBAction func showHudWithLoadingIndicator(_ sender: UIButton) {
        APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            APESuperHUD.dismissAll(animated: true)
        })
        
        // Or create a instance of APESuperHud
        
        /*
        let hudViewController = APESuperHUD(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        present(hudViewController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            hudViewController.dismiss(animated: true)
        })
        */
    }
    
    @IBAction func showHudWithTitleAndMessage(_ sender: UIButton) {
        APESuperHUD.show(style: .textOnly, title: "Hello", message: "world")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            APESuperHUD.dismissAll(animated: true)
        })
        
        // Or create a instance of APESuperHud
        
        /*
        let hudViewController = APESuperHUD(style: .textOnly, title: "Hello", message: "world")
        present(hudViewController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            hudViewController.dismiss(animated: true)
        })
        */
    }
    
    @IBAction func showHudWithUpdates(_ sender: UIButton) {
        APESuperHUD.show(style: .loadingIndicator(type: .standard), title: nil, message: "Loading...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            APESuperHUD.show(style: .textOnly, title: "Done loading", message: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                let image = UIImage(named: "apegroup")!
                APESuperHUD.show(style: .icon(image: image, duration: 3.0), title: nil, message: nil)
            })
        })
    }
}

