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
    
    @IBOutlet weak var particleEffectSwitch: UISwitch!
    @IBOutlet weak var messageWithDefaultIconButton: UIButton!
    @IBOutlet weak var messageWithCustomIconButton: UIButton!
    @IBOutlet weak var messageWithTitleButton: UIButton!
    @IBOutlet weak var loadingWithTextButton: UIButton!
    @IBOutlet weak var loadingWithoutTextButton: UIButton!
    @IBOutlet weak var loadingWithFunnyMessagesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Appearnce
        setupHudAppearance()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup Buttons
        setupButtonsLayout()
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
    
    private func setupButtonsLayout() {
        
        messageWithDefaultIconButton.layer.cornerRadius = messageWithDefaultIconButton.frame.height / 2
        messageWithCustomIconButton.layer.cornerRadius = messageWithCustomIconButton.frame.height / 2
        messageWithTitleButton.layer.cornerRadius = messageWithTitleButton.frame.height / 2
        loadingWithTextButton.layer.cornerRadius = loadingWithFunnyMessagesButton.frame.height / 2
        loadingWithoutTextButton.layer.cornerRadius = loadingWithoutTextButton.frame.height / 2
        loadingWithFunnyMessagesButton.layer.cornerRadius = loadingWithFunnyMessagesButton.frame.height / 2
        
    }
    
    @IBAction func withDefaultIconButtonPressed(sender: UIButton) {
        
        let sksFileName: String? = particleEffectSwitch.isOn ? "FireFliesParticle" : nil
        
        APESuperHUD.showOrUpdateHUD(icon: .email, message: "1 new message", duration: 3.0, particleEffectFileName: sksFileName, presentingView: self.view, completion: { _ in
            // Completed
        })
        
    }
    
    @IBAction func withCustomIconButtonPressed(sender: UIButton) {
        
        let sksFileName: String? = particleEffectSwitch.isOn ? "FireFliesParticle" : nil
        
        APESuperHUD.showOrUpdateHUD(icon: UIImage(named: "apegroup")!, message: "Demo message", duration: 3.0, particleEffectFileName: sksFileName, presentingView: self.view, completion: { _ in
            // Completed
        })
        
    }
    
    @IBAction func withTitleButtonPressed(sender: UIButton) {
        
        let sksFileName: String? = particleEffectSwitch.isOn ? "FireFliesParticle" : nil
        
        APESuperHUD.showOrUpdateHUD(title: "Title", message: "Demo message", duration: 3.0, particleEffectFileName: sksFileName, presentingView: self.view, completion: { _ in
            // Completed
        })
        
    }
    
    @IBAction func withLoadingTextButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Demo loading...", presentingView: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let strongSelf = self else { return }
            
            let sksFileName: String? = strongSelf.particleEffectSwitch.isOn ? "FireFliesParticle" : nil
            
            APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "Done loading!", duration: 3.0, particleEffectFileName: sksFileName, presentingView: strongSelf.view, completion: nil)
            
        }
    }
    
    @IBAction func withoutLoadingTextButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "", presentingView: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let strongSelf = self else { return }
            APESuperHUD.removeHUD(animated: true, presentingView: strongSelf.view, completion: nil)
        }
    }
    
    @IBAction func withFunnyLoadingTextButtonPressed(sender: UIButton) {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, funnyMessagesLanguage: .english, presentingView: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            guard let strongSelf = self else { return }
            APESuperHUD.removeHUD(animated: true, presentingView: strongSelf.view, completion: nil)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

