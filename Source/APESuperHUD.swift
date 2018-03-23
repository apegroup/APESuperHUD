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
    @IBOutlet private weak var stackView: UIStackView!
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
    
    private var window: UIWindow?
    
    private var _title: String? {
        didSet {
            titleLabel.isHidden = (_title?.isEmpty ?? true) ? true : false
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
            messageLabel.isHidden = (message?.isEmpty ?? true) ? true : false
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
            vc.setStyle(style, animated: true)
            vc.setTitle(title, animated: true)
            vc.setMessage(message, animated: true)
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
        
        setStyle(style, animated: false)
        setTitle(_title, animated: false)
        setMessage(message, animated: false)
       
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
            let delay: TimeInterval = 2
//        let delay: TimeInterval = isAnimating ? (APESuperHUD.appearance.animateInTime + 0.1) : 0
//
//        isAnimating = true
            
            UIView.animate(withDuration: APESuperHUD.appearance.animateOutTime, animations: {
          
                self.hudView.alpha = 0.0
                self.view.alpha = 0
                }, completion: { isFinished in
                    // self?.isAnimating = false
                    if isFinished {
                        super.dismiss(animated: flag, completion: completion)
                         APESuperHUD_new.window = nil
                    }
            })
        } else {
            super.dismiss(animated: flag, completion: completion)
            APESuperHUD_new.window = nil
        }
    }
    
    private func startDismissTimer() {
        self.dismissTask?.cancel()
        
        guard let duration = duration else { return }
        
        let dismissTask = DispatchWorkItem { [weak self] in
            self?.dismiss(animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: dismissTask)
        self.dismissTask = dismissTask
    }
    
    public static func dismissAll(animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if HUDAppearance_new.cancelableOnTouch {
            dismissTask?.cancel()
            dismiss(animated: true)
        }
    }
    
    public func setStyle(_ style: HUDStyle, animated: Bool) {
       
        self.style = style
        startDismissTimer()
//        
//        let animatingTime = HUDAppearance_new.animateInTime
//        
//        UIView.animate(withDuration: animatingTime, delay: 0, options: .curveEaseInOut, animations: {
//            self.stackView.alpha = 0
//        }) { (isSuccess) in
//            self.style = style
//        }
//        
//        UIView.animate(withDuration: animatingTime, delay: animatingTime + 0.3, options: .curveEaseInOut, animations: {
//            self.stackView.alpha = 1
//        })
//        
        
//        UIView.animate(withDuration: HUDAppearance_new.animateInTime, animations: {
//
//            self.stackView.alpha = 0.0
//
//        }) { (_) in
//
//            self.style = style
//
//            UIView.animate(withDuration: HUDAppearance_new.animateInTime, animations: {
//
//                 self.stackView.alpha = 1.0
//            })
//        }
        
        
//        if animated {
//            UIView.animate(withDuration: HUDAppearance_new.animateInTime) {
//                self.style = style
//            }
//        } else {
//            self.style = style
//        }
    }
    
    public func setTitle(_ title: String?, animated: Bool) {
        if animated {
            UIView.animate(withDuration: HUDAppearance_new.animateInTime) {
                self._title = title
            }
        } else {
            self._title = title
        }
    }
    
    public func setMessage(_ message: String?, animated: Bool) {
        if animated {
            UIView.animate(withDuration: HUDAppearance_new.animateInTime) {
                self.message = message
            }
        } else {
            self.message = message
        }
    }

}
