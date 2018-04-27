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
            setStyle(oldValue: oldValue, animated: true)
        }
    }
    
    private var window: UIWindow?
    
    private var _title: String? {
        didSet {
            if oldValue == _title {
                return
            }
            
            UIView.animate(withDuration: HUDAppearance_new.animateOutTime, animations: {
                self.titleLabel.alpha = 0
            }, completion: { isFinished in
                guard isFinished else { return }
                
                self.titleLabel.text = self._title
                
                UIView.animate(withDuration: HUDAppearance_new.animateInTime, animations: {
                    self.titleLabel.alpha = 1
                })
            })
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
            if oldValue == message {
                return
            }
            
            UIView.animate(withDuration: HUDAppearance_new.animateOutTime, animations: {
                self.messageLabel.alpha = 0
            }, completion: { isFinished in
                guard isFinished else { return }
                
                self.messageLabel.text = self.message
                
                UIView.animate(withDuration: HUDAppearance_new.animateInTime, animations: {
                    self.messageLabel.alpha = 1
                })
            })
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
        if let vc = UIApplication.shared.windows.map({ $0.rootViewController }).compactMap({ $0 as? APESuperHUD_new }).first {
            vc.style = style
            vc.title = title
            vc.message = message
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
        
        setStyle(animated: false)
        titleLabel.text = _title
        messageLabel.text = message
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
            UIView.animate(withDuration: HUDAppearance_new.animateOutTime, animations: {
                self.hudView.alpha = 0
                self.view.alpha = 0
            }, completion: { isFinished in
                if isFinished {
                    if APESuperHUD_new.window != nil {
                        completion?()
                        APESuperHUD_new.window = nil
                    }
                    
                    super.dismiss(animated: flag, completion: completion)
                }
            })
        } else {
            if APESuperHUD_new.window != nil {
                completion?()
                APESuperHUD_new.window = nil
            }
            
            super.dismiss(animated: flag, completion: completion)
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
        if let vc = UIApplication.shared.windows.map({ $0.rootViewController }).compactMap({ $0 as? APESuperHUD_new }).first {
            vc.dismiss(animated: flag, completion: completion)
        }
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if duration != nil {
            return
        }
        
        if HUDAppearance_new.cancelableOnTouch {
            dismissTask?.cancel()
            dismiss(animated: true)
        }
    }
    
    private func setStyle(oldValue: HUDStyle? = nil, animated: Bool) {
        switch style {
        case .icon(let tuple):
            if let oldValue = oldValue, case let .icon(oldTuple) = oldValue, oldTuple.image == tuple.image {
                return
            }
            
            if animated {
                UIView.animate(withDuration: HUDAppearance_new.animateOutTime, animations: {
                    self.loadingIndicatorView.alpha = 0
                    self.iconImageView.alpha = 0
                }, completion: { isFinished in
                    guard isFinished else { return }
                    
                    self.iconImageView.image = tuple.image
                    self.iconImageView.isHidden = false
                    self.iconContainerView.isHidden = false
                    self.loadingIndicatorView.isHidden = true
                    
                    UIView.animate(withDuration: HUDAppearance_new.animateInTime, animations: {
                        self.iconImageView.alpha = 1
                        self.iconContainerView.alpha = 1
                    })
                    
                    self.startDismissTimer()
                })
            } else {
                loadingIndicatorView.isHidden = true
                iconImageView.isHidden = false
                iconContainerView.isHidden = false
                iconImageView.image = tuple.image
            }
            
        case .loadingIndicator(_):
            if let oldValue = oldValue, case .loadingIndicator = oldValue {
                return
            }
            
            if animated {
                UIView.animate(withDuration: HUDAppearance_new.animateOutTime, animations: {
                    self.loadingIndicatorView.alpha = 0
                    self.iconImageView.alpha = 0
                }, completion: { isFinished in
                    guard isFinished else { return }
                    
                    self.loadingIndicatorView.isHidden = false
                    self.iconImageView.isHidden = true
                    
                    UIView.animate(withDuration: HUDAppearance_new.animateInTime, animations: {
                        self.loadingIndicatorView.alpha = 1
                    })
                    
                    self.startDismissTimer()
                })
            } else {
                iconImageView.isHidden = true
                loadingIndicatorView.isHidden = false
                iconContainerView.isHidden = true
            }
            
        case .textOnly:
            if animated {
                UIView.animate(withDuration: HUDAppearance_new.animateOutTime, animations: {
                    self.loadingIndicatorView.alpha = 0
                    self.iconImageView.alpha = 0
                    self.iconContainerView.alpha = 0
                }, completion: { isFinished in
                    guard isFinished else { return }
                    
                    self.loadingIndicatorView.isHidden = true
                    self.iconImageView.isHidden = true
                    self.iconContainerView.isHidden = true
                    
                    self.startDismissTimer()
                })
            } else {
                loadingIndicatorView.isHidden = true
                iconImageView.isHidden = true
                iconContainerView.isHidden = true
            }
        }
    }
}
