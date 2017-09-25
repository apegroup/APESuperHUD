// HudView.swift
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
import SpriteKit


class HudView: UIView {
    
    internal let hudMessageView: UIView
    internal let iconImageView: UIImageView
    internal let loadingActivityIndicator: UIActivityIndicatorView
    internal let titleLabel: UILabel
    internal let informationLabel: UILabel
    internal var iconImageWidthConstraint: NSLayoutConstraint!
    internal var iconImageHeightConstraint: NSLayoutConstraint!
    internal var iconTopConstraint: NSLayoutConstraint!
    internal var iconCenterYConstraint: NSLayoutConstraint!
    internal var hudMinimumHeightConstraint: NSLayoutConstraint!
    internal var hudWidthConstraint: NSLayoutConstraint!
    
    var isActivityIndicatorSpinnning: Bool {
        
        get {
            return self.loadingActivityIndicator.isAnimating
        }
        
    }
    
    var isActiveTimer: Bool = false {
        willSet {
            if !newValue {
                timer.invalidate()
            }
        }
    }
    
    fileprivate var isAnimating: Bool = false
    fileprivate var timer = Timer()
    fileprivate var loadingMessagesHandler: LoadingMessagesHandler!
    fileprivate var effectView: UIView?
    
    
    /**
     Initiates the HUD view, sets up constraints, and adds subviews.
     
     - parameter frame: the frame
     
     */
    internal override init(frame: CGRect) {
        
        hudMessageView = UIView()
        hudMessageView.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        informationLabel = UILabel()
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.textAlignment = .center
        informationLabel.numberOfLines = 0
        
        loadingActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        hudMessageView.addSubview(iconImageView)
        hudMessageView.addSubview(loadingActivityIndicator)
        hudMessageView.addSubview(titleLabel)
        hudMessageView.addSubview(informationLabel)
        
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        addSubview(hudMessageView)
        generateConstraints()
        setupGestureRecognizers()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Lifecycle

extension HudView {
    
    override internal func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let bounds = newSuperview?.bounds {
            frame = bounds
            
            if let blurEffectView = blurEffectView() {
                backgroundColor = UIColor.clear
                insertSubview(blurEffectView, at: 0)
            }
            
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            // HUD Size
            if APESuperHUD.appearance.hudSquareSize < frame.width && APESuperHUD.appearance.hudSquareSize < frame.height {
                hudWidthConstraint.constant = APESuperHUD.appearance.hudSquareSize
                hudMinimumHeightConstraint.constant = APESuperHUD.appearance.hudSquareSize
                
            } else {
                let size = frame.width <= frame.height ? frame.width : frame.height
                hudWidthConstraint.constant = size
                hudMinimumHeightConstraint.constant = size
            }
            
            // Icon size
            iconImageWidthConstraint.constant = APESuperHUD.appearance.iconWidth
            iconImageHeightConstraint.constant = APESuperHUD.appearance.iconHeight
        }
        
    }
    
    override internal func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupDefaultState()
        animateInHud()
        
    }
}


// MARK: - API

extension HudView {
    
    /**
     Creates a HUD view according the appearance struct.
     
     */
    static func create() -> HudView {
        
        let view: HudView = HudView(frame: UIScreen.main.bounds)
        
        // Colors
        view.titleLabel.textColor = APESuperHUD.appearance.textColor
        view.informationLabel.textColor = APESuperHUD.appearance.textColor
        view.hudMessageView.backgroundColor = APESuperHUD.appearance.foregroundColor
        view.backgroundColor = APESuperHUD.appearance.backgroundColor
        view.iconImageView.tintColor = APESuperHUD.appearance.iconColor
        view.loadingActivityIndicator.color = APESuperHUD.appearance.loadingActivityIndicatorColor
        
        // Corner radius
        view.hudMessageView.layer.cornerRadius = CGFloat(APESuperHUD.appearance.cornerRadius)
        
        // Shadow
        if APESuperHUD.appearance.shadow {
            view.hudMessageView.layer.shadowColor = UIColor.black.cgColor
            view.hudMessageView.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.hudMessageView.layer.shadowRadius = 6.0
            view.hudMessageView.layer.shadowOpacity = 0.15
        }
        
        // Font
        let titleFont = UIFont(name: APESuperHUD.appearance.titleFontName, size: APESuperHUD.appearance.titleFontSize)
        
        let messageFont = UIFont(name: APESuperHUD.appearance.messageFontName, size: APESuperHUD.appearance.messageFontSize)
        view.titleLabel.font = titleFont
        view.informationLabel.font = messageFont
        
        return view
    }
    
    
    /**
     Removes HUD from view
     
     - parameter animated: Sets whether the HUD should be removed animated or not.
     - parameter onDone: The completion block that will be triggered after the HUD view is removed from it's super view.
     
     */
    func removeHud(animated: Bool, onDone: (() -> Void)?) {
        
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
        
        if animated {
            animateOutHud(completion: { [weak self] in
                
                self?.effectView?.removeFromSuperview()
                self?.removeFromSuperview()
                
                onDone?()
                
                })
            
        } else {
            
            self.effectView?.removeFromSuperview()
            self.removeFromSuperview()
            
            onDone?()
            
        }
        
    }
    
    func showMessages(messages: [String]) {
        
        loadingMessagesHandler = LoadingMessagesHandler(messages: messages)
        let showMessagesSelector = #selector(showMessages as () -> Void)
        showMessages()
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: showMessagesSelector, userInfo: nil, repeats: true)
    }
    
    @objc func showMessages() {
        
        let message = loadingMessagesHandler.firstMessage()
        if isActiveTimer {
            hideViewsAnimated(views: [informationLabel], completion: { [weak self] in
                self?.showLoadingActivityIndicator(text: message, completion: nil)
                })
        }
    }
    
    func showFunnyMessages(languageType: LanguageType) {
        
        loadingMessagesHandler = LoadingMessagesHandler(languageType: languageType)
        let showFunnyMessagesSelector = #selector(showFunnyMessages as () -> Void)
        showFunnyMessages()
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: showFunnyMessagesSelector, userInfo: nil, repeats: true)
    }
    
    @objc func showFunnyMessages() {
        
        let funnyMessage = loadingMessagesHandler.randomMessage()
        if isActiveTimer {
            hideViewsAnimated(views: [informationLabel], completion: { [weak self] in
                self?.showLoadingActivityIndicator(text: funnyMessage, completion: nil)
                })
        }
    }
    
    func showLoadingActivityIndicator(text: String?, completion: (() -> Void)?) {
        
        iconImageView.alpha = 0.0
        informationLabel.text = text ?? ""
        updateIconConstraints()
        
        loadingActivityIndicator.startAnimating()
        
        showViewsAnimated(views: [loadingActivityIndicator, informationLabel], completion: { 
            
            completion?()
            
        })
        
    }
    
    func hideLoadingActivityIndicator(completion: (() -> Void)?) {
        
        hideViewsAnimated(views: [loadingActivityIndicator, informationLabel], completion: { [weak self] in
            
            self?.loadingActivityIndicator.stopAnimating()
            
            completion?()
            
            })
        
    }
    
    func showMessage(title: String?, message: String?, icon: UIImage?, completion: (() -> Void)?) {
        
        titleLabel.text = title
        informationLabel.text = message
        updateIconConstraints()
        
        if icon != nil {
            alpha = 1.0
            iconImageView.image = icon
            loadingActivityIndicator.alpha = 0
            loadingActivityIndicator.stopAnimating()
        }
        
        showViewsAnimated(views: [titleLabel, informationLabel, iconImageView], completion: { 
            
            completion?()
            
        })
        
    }
    
    /**
     Adds a particle effect in the background
     
     - parameter sksfileName: The name of the Sprite Kit particle effect file.
     
     */
    func addParticleEffect(sksfileName: String) {
        
        guard let emitter = SKEmitterNode(fileNamed: sksfileName) else { return }
    
        // Can't have particle effect together witha a blur effect view
        for subview in subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
       
        emitter.position = CGPoint(x: center.x, y: center.y)
        emitter.zPosition = 0
        
        let skView = SKView()
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.allowsTransparency = true
        skView.alpha = 0.0
        
        let skScene:SKScene = SKScene(size: bounds.size)
        skScene.scaleMode = .resizeFill
        skScene.backgroundColor = APESuperHUD.appearance.particleEffectBackgroundColor
        skScene.addChild(emitter)
        
        insertSubview(skView, at: 0)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: skView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: skView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: skView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: skView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            ])
        
        skView.presentScene(skScene, transition: SKTransition.crossFade(withDuration: 4))
        
        UIView.animate(withDuration: APESuperHUD.appearance.animateInTime) {
            skView.alpha = 1.0
        }
        
    }
    
}


// MARK: - Setup

extension HudView {
    
    /**
     Manage generating constraints.
     
     */
    fileprivate func generateConstraints() {
        
        generateMessageViewConstraints()
        generateIconConstraints()
        generateLoadingIndicatorConstraints()
        generateTitleLabelConstraints()
        generateMessageLabelConstraints()
    }
    
    fileprivate func setupGestureRecognizers() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HudView.tapGestureRecognized(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    fileprivate func generateMessageViewConstraints() {
        
        let centerXConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: APESuperHUD.appearance.hudSquareSize)
        
        let minimumHeightConstraint = NSLayoutConstraint(item: hudMessageView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: APESuperHUD.appearance.hudSquareSize)
        
        widthConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Int(UILayoutPriority.required.rawValue) - 1))
        minimumHeightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Int(UILayoutPriority.required.rawValue) - 1))
        
        [centerXConstraint, minimumHeightConstraint, centerYConstraint, widthConstraint].forEach {
            $0.isActive = true
        }
        
        hudWidthConstraint = widthConstraint
        hudMinimumHeightConstraint = minimumHeightConstraint
    }
    
    fileprivate func generateIconConstraints() {
        
        let centerXConstraint = NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: hudMessageView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: hudMessageView, attribute: .centerY, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: iconImageView, attribute: .top, relatedBy: .equal, toItem: hudMessageView, attribute: .top, multiplier: 1, constant: 30)
        let widthConstraint = NSLayoutConstraint(item: iconImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        let heightConstraint = NSLayoutConstraint(item: iconImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        
        [centerXConstraint, topConstraint, widthConstraint, heightConstraint].forEach {
            $0.isActive = true
        }
        
        iconImageWidthConstraint = widthConstraint
        iconImageHeightConstraint = heightConstraint
        iconCenterYConstraint = centerYConstraint
        iconTopConstraint = topConstraint
    }
    
    fileprivate func generateLoadingIndicatorConstraints() {
        
        let centerXConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        let heightConstraint = NSLayoutConstraint(item: loadingActivityIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48)
        
        [centerXConstraint, centerYConstraint, widthConstraint, heightConstraint].forEach {
            $0.isActive = true
        }
    }
    
    fileprivate func generateTitleLabelConstraints() {
        let centerXConstraint = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: hudMessageView, attribute: .centerX, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: hudMessageView, attribute: .top, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 144)
        let heightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 21)
        
        [centerXConstraint, topConstraint, widthConstraint, heightConstraint].forEach {
            $0.isActive = true
        }
        
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
    }
    
    
    fileprivate func generateMessageLabelConstraints() {
        
        let topConstraint = NSLayoutConstraint(item: informationLabel, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1, constant: 8)
        let bottomConstraint = NSLayoutConstraint(item: informationLabel, attribute: .bottom, relatedBy: .equal, toItem: hudMessageView, attribute: .bottom, multiplier: 1, constant: -20)
        let leadingConstraint = NSLayoutConstraint(item: informationLabel, attribute: .leading, relatedBy: .equal, toItem: hudMessageView, attribute: .leading, multiplier: 1, constant: 5)
        let trailingConstraint = NSLayoutConstraint(item: informationLabel, attribute: .trailing, relatedBy: .equal, toItem: hudMessageView, attribute: .trailing, multiplier: 1, constant: -5)
        
        [topConstraint, bottomConstraint, leadingConstraint, trailingConstraint].forEach {
            $0.isActive = true
        }
        
        informationLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
    }
    
    fileprivate func updateIconConstraints() {
        
        let emptyMessage = (informationLabel.text ?? "").isEmpty
        
        iconTopConstraint.isActive = !emptyMessage
        iconCenterYConstraint.isActive = emptyMessage
    }

    
    /**
     Sets up the HUD default state.
     
     */
    fileprivate func setupDefaultState() {
        
        //We can't set alpha in combination with a blur effect view
        alpha = APESuperHUD.appearance.backgroundBlurEffect == .none ? 0 : 1
        
        hudMessageView.alpha = 0.0
        titleLabel.alpha = 0.0
        informationLabel.alpha = 0.0
        iconImageView.alpha = 0.0
        loadingActivityIndicator.alpha = 0.0
        loadingActivityIndicator.stopAnimating()
        
        layoutIfNeeded()
        
    }
    
    /**
     Creates a blur effect view.
     
     */
    fileprivate func blurEffectView() -> UIView? {
        
        var blurEffect: UIBlurEffect?
        
        switch APESuperHUD.appearance.backgroundBlurEffect {
            
        case .dark:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.dark)
            
        case .light:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.light)
            
        case .extraLight:
            blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            
        case .none:
            return nil
            
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        
        return blurEffectView
        
    }
    
}


// MARK: - User Interactions
extension HudView {
    
    @IBAction func tapGestureRecognized(sender: AnyObject) {
        
        if APESuperHUD.appearance.cancelableOnTouch {
            removeHud(animated: true, onDone: nil)
        }
        
    }
    
    @objc func deviceOrientationDidChange() {
        
        guard let superview = superview else {
            return
        }
        
        frame = superview.bounds
        effectView?.frame = frame
        layoutIfNeeded()
    }
    
}


// MARK: - Animations

extension HudView {
    
    /**
     Animates in the HUD.
     
     - parameter completion: The completion block that will be trigger when the animation is finished
     
     */
    fileprivate func animateInHud() {
        
        hudMessageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        layoutIfNeeded()
        
        UIView.animate(withDuration: APESuperHUD.appearance.animateInTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: { [weak self] in
            
            self?.hudMessageView.alpha = 1.0
            self?.alpha = 1.0
            self?.hudMessageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            self?.layoutIfNeeded()
            }
        )
        
    }
    
    /**
     Animates out the HUD.
     
     - parameter completion: The completion block that will be trigger when the animation is finished
     
     */
    fileprivate func animateOutHud(completion: @escaping () -> Void) {
        
        let delay: TimeInterval = isAnimating ? (APESuperHUD.appearance.animateInTime + 0.1) : 0
        
        isAnimating = true
        
        UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] in
            
            self?.alpha = 0.0
            
            }, completion: { [weak self] _ in
                
                self?.isAnimating = false
                completion()
                
            })
        
    }
    
    /**
     Animates in a array of views.
     
     - parameter views: the array of views to animate in
     - parameter completion: The completion block that will be trigger when the animation of views are finished
     
     */
    fileprivate func showViewsAnimated(views: [UIView], completion: @escaping () -> Void ) {
        
        let delay: TimeInterval = isAnimating ? APESuperHUD.appearance.animateInTime : 0
        
        isAnimating = true
        
        UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            for view in views {
                view.alpha = 1.0
            }
            
            }, completion: { [weak self] _ in
                
                self?.isAnimating = false
                completion()
                
            })
        
    }
    
    /**
     Animates out a array of views.
     
     - parameter views: the array of views to animate ot
     - parameter completion: The completion block that will be trigger when the animation of views are finished
     
     */
    fileprivate func hideViewsAnimated(views: [UIView], completion: @escaping () -> Void ) {
        
        let delay: TimeInterval = isAnimating ? APESuperHUD.appearance.animateInTime : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.1, execute: {
            
            self.isAnimating = true
            UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, animations: {
                
                for view in views {
                    view.alpha = 0.0
                }
                
                }, completion: { [weak self] _ in
                    self?.isAnimating = false
                    completion()
                })
            
        })
        
    }
    
}
