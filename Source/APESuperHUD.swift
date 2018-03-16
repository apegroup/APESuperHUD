//
//  APESuperHUD.swift
//  APESuperHUD
//
//  Created by Daniel Nilsson on 2018-02-23.
//  Copyright © 2018 Apegroup. All rights reserved.
//

import UIKit

public class APESuperHUD_new: UIViewController {
    
    @IBOutlet private weak var hudView: UIView!
    @IBOutlet private weak var hudViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var hudViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var iconContainerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    public var style: HUDStyle {
        didSet {
            switch style {
            case .icon(let tuple):
                loadingIndicatorView.isHidden = true
                iconImageView.isHidden = false
                iconContainerView.isHidden = false
                iconImageView.image = tuple.image
                
            case .loadingIndicator(let type):
                iconImageView.isHidden = true
                loadingIndicatorView.isHidden = false
                iconContainerView.isHidden = true
                switch type {
                case .standard:
                    break
                }
            }
        }
    }
    
    private var _title: String? {
        didSet {
            titleLabel.text = _title
        }
    }
    public override var title: String? {
        get {
            return _title
        }
        set {
            _title = title
        }
    }
    
    public var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    public var duration: TimeInterval? {
        if case let .icon(tuple) = style {
            return tuple.duration
        } else {
            return nil
        }
    }
    
    private static var window: UIWindow?
    private var dismissTask: DispatchWorkItem?
    
    public init(style: HUDStyle, title: String? = nil, message: String? = nil) {
        self.style = style
        self._title = title
        self.message = message
        
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: APESuperHUD_new.self)
        super.init(nibName: nibName, bundle: bundle)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        startDismissTimer()
    }
    
    public static func show(style: HUDStyle, title: String? = nil, message: String? = nil) {
        if let vc = UIApplication.shared.windows.map({ $0.rootViewController }).flatMap({ $0 as? APESuperHUD_new }).first {
            vc.style = style
            vc.title = title
            vc.message = message
            
            vc.startDismissTimer()
        } else {
            let vc = APESuperHUD_new(style: style, title: title, message: message)
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .clear
            window.rootViewController = vc
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        hudView.alpha = 0
        
        titleLabel.textColor = HUDAppearance_new.textColor
        view.backgroundColor = HUDAppearance_new.backgroundColor
        hudView.backgroundColor = HUDAppearance_new.foregroundColor
        loadingIndicatorView.color = HUDAppearance_new.loadingActivityIndicatorColor
        hudView.layer.masksToBounds = true
        hudView.layer.cornerRadius = HUDAppearance_new.cornerRadius
        
        if HUDAppearance_new.shadow {
            hudView.layer.shadowColor = HUDAppearance_new.shadowColor.cgColor
            hudView.layer.shadowOffset = HUDAppearance_new.shadowOffset
            hudView.layer.shadowRadius = HUDAppearance_new.shadowRadius
            hudView.layer.shadowOpacity = HUDAppearance_new.shadowOpacity
        }
        
        messageLabel.font = HUDAppearance_new.messageFont
        titleLabel.font = HUDAppearance_new.titleFont
        
        iconWidthConstraint.constant = HUDAppearance_new.iconSize.width
        iconHeightConstraint.constant = HUDAppearance_new.iconSize.height
        
        hudViewWidthConstraint.constant = HUDAppearance_new.hudSize.width
        hudViewHeightConstraint.constant = HUDAppearance_new.hudSize.height
        
        titleLabel.text = _title
        messageLabel.text = message
        setStyle(style, animated: false)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateInHud()
    }
    
    private func animateInHud() {
        hudView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: HUDAppearance_new.animateInTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.hudView.alpha = 1.0
            self?.view.alpha = 1.0
            self?.hudView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            self?.view.layoutIfNeeded()
            }
        )
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            let delay: TimeInterval = 0
//        let delay: TimeInterval = isAnimating ? (APESuperHUD.appearance.animateInTime + 0.1) : 0
//
//        isAnimating = true
            
            UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] in
                self?.hudView.alpha = 0.0
                self?.view.alpha = 0
                }, completion: { _ in
                    // self?.isAnimating = false
                    super.dismiss(animated: false, completion: completion)
            })
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    private func startDismissTimer() {
        self.dismissTask?.cancel()
        
        guard let duration = duration else {
            return
        }
        
        let dismissTask = DispatchWorkItem { [weak self] in
            self?.dismiss(animated: true)
            APESuperHUD_new.window = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: dismissTask)
        self.dismissTask = dismissTask
    }
    
    public static func dismissAll(animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if HUDAppearance_new.cancelableOnTouch {
            dismiss(animated: true)
        }
    }
    
    public func setTitle(_ title: String, animated: Bool) {
        if animated {
            
        } else {
            
        }
    }
    
    public func setStyle(_ style: HUDStyle, animated: Bool) {
        dismissTask?.cancel()
        startDismissTimer()
        
        if animated {
            UIView.animate(withDuration: HUDAppearance_new.animateInTime) {
                self.style = style
            }
        } else {
            self.style = style
        }
    }
}
