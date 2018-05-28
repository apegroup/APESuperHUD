// APESuperHUD.swift
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

public class APESuperHUD: UIViewController {
    
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
            
            UIView.animate(withDuration: HUDAppearance.animateOutTime, animations: {
                self.titleLabel.alpha = 0
            }, completion: { isFinished in
                guard isFinished else { return }
                
                self.titleLabel.text = self._title
                
                UIView.animate(withDuration: HUDAppearance.animateInTime, animations: {
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
            _title = newValue
        }
    }
    
    public var message: String? {
        didSet {
            if oldValue == message {
                return
            }
            
            UIView.animate(withDuration: HUDAppearance.animateOutTime, animations: {
                self.messageLabel.alpha = 0
            }, completion: { isFinished in
                guard isFinished else { return }
                
                self.messageLabel.text = self.message
                
                UIView.animate(withDuration: HUDAppearance.animateInTime, animations: {
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
    private var completionBlock: (() -> Void)?
    
    public init(style: HUDStyle, title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
        self.style = style
        self._title = title
        self.message = message
        self.completionBlock = completion
        
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: APESuperHUD.self)
        super.init(nibName: nibName, bundle: bundle)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        startDismissTimer()
    }
    
    public static func show(style: HUDStyle, title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
        if let vc = UIApplication.shared.windows.map({ $0.rootViewController }).compactMap({ $0 as? APESuperHUD }).first {
            vc.style = style
            vc.title = title
            vc.message = message
            vc.completionBlock = completion
        } else {
            let vc = APESuperHUD(style: style, title: title, message: message, completion: completion)
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
        
        titleLabel.textColor = HUDAppearance.titleTextColor
        messageLabel.textColor = HUDAppearance.messageTextColor
        view.backgroundColor = HUDAppearance.backgroundColor
        hudView.backgroundColor = HUDAppearance.foregroundColor
        loadingIndicatorView.color = HUDAppearance.loadingActivityIndicatorColor
        hudView.layer.masksToBounds = true
        hudView.layer.cornerRadius = HUDAppearance.cornerRadius
        
        if HUDAppearance.shadow {
            hudView.layer.shadowColor = HUDAppearance.shadowColor.cgColor
            hudView.layer.shadowOffset = HUDAppearance.shadowOffset
            hudView.layer.shadowRadius = HUDAppearance.shadowRadius
            hudView.layer.shadowOpacity = HUDAppearance.shadowOpacity
            hudView.clipsToBounds = false
        }
        iconImageView.tintColor = HUDAppearance.iconColor
        
        messageLabel.font = HUDAppearance.messageFont
        titleLabel.font = HUDAppearance.titleFont
        
        iconWidthConstraint.constant = HUDAppearance.iconSize.width
        iconHeightConstraint.constant = HUDAppearance.iconSize.height
        
        hudViewWidthConstraint.constant = HUDAppearance.hudSize.width
        hudViewHeightConstraint.constant = HUDAppearance.hudSize.height
        
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
        
        UIView.animate(withDuration: HUDAppearance.animateInTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.hudView.alpha = 1.0
            self?.view.alpha = 1.0
            self?.hudView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            self?.view.layoutIfNeeded()
            }
        )
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            UIView.animate(withDuration: HUDAppearance.animateOutTime, animations: {
                self.hudView.alpha = 0
                self.view.alpha = 0
            }, completion: { isFinished in
                self.completionBlock?()
                if isFinished {
                    if APESuperHUD.window != nil {
                        completion?()
                        APESuperHUD.window = nil
                    }
                    
                    super.dismiss(animated: flag, completion: completion)
                }
            })
        } else {
            completionBlock?()
            
            if APESuperHUD.window != nil {
                completion?()
                APESuperHUD.window = nil
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
        if let vc = UIApplication.shared.windows.map({ $0.rootViewController }).compactMap({ $0 as? APESuperHUD }).first {
            vc.dismiss(animated: flag, completion: completion)
        }
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if duration != nil {
            return
        }
        
        if HUDAppearance.cancelableOnTouch {
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
                let delay = loadingIndicatorView.alpha == 0 && iconImageView.alpha == 0 ? HUDAppearance.animateOutTime : 0
                UIView.animate(withDuration: HUDAppearance.animateOutTime, animations: {
                    self.loadingIndicatorView.alpha = 0
                    self.iconImageView.alpha = 0
                }, completion: { isFinished in
                    guard isFinished else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                        self.iconImageView.image = tuple.image
                        self.iconImageView.isHidden = false
                        self.iconContainerView.isHidden = false
                        self.loadingIndicatorView.isHidden = true
                        
                        UIView.animate(withDuration: HUDAppearance.animateInTime, animations: {
                            self.iconImageView.alpha = 1
                            self.iconContainerView.alpha = 1
                        })
                        
                        self.startDismissTimer()
                    })
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
                let delay = loadingIndicatorView.alpha == 0 && iconImageView.alpha == 0 ? HUDAppearance.animateOutTime : 0
                UIView.animate(withDuration: HUDAppearance.animateOutTime, animations: {
                    self.loadingIndicatorView.alpha = 0
                    self.iconImageView.alpha = 0
                }, completion: { isFinished in
                    guard isFinished else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                        self.loadingIndicatorView.isHidden = false
                        self.iconImageView.isHidden = true
                        
                        UIView.animate(withDuration: HUDAppearance.animateInTime, animations: {
                            self.loadingIndicatorView.alpha = 1
                        })
                        
                        self.startDismissTimer()
                    })
                })
            } else {
                iconImageView.isHidden = true
                loadingIndicatorView.isHidden = false
                iconContainerView.isHidden = true
            }
            
        case .textOnly:
            if animated {
                let delay = loadingIndicatorView.alpha == 0 && iconImageView.alpha == 0 && iconContainerView.alpha == 0 ? HUDAppearance.animateOutTime : 0
                UIView.animate(withDuration: HUDAppearance.animateOutTime, animations: {
                    self.loadingIndicatorView.alpha = 0
                    self.iconImageView.alpha = 0
                    self.iconContainerView.alpha = 0
                }, completion: { isFinished in
                    guard isFinished else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                        self.loadingIndicatorView.isHidden = true
                        self.iconImageView.isHidden = true
                        self.iconContainerView.isHidden = true
                        
                        self.startDismissTimer()
                    })
                })
            } else {
                loadingIndicatorView.isHidden = true
                iconImageView.isHidden = true
                iconContainerView.isHidden = true
            }
        }
    }
}
