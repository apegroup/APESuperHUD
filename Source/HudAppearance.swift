// HUDAppearance.swift
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

/**
 The blur effect of the view where the HUD is presented in
 
 - None: No blur effect.
 - Dark: Dark blur.
 - Light: Light blur.
 - ExtraLight: Extra light blur.
*/
public enum BlurEffect {
    
    case none
    case dark
    case light
    case extraLight
}

public struct HUDAppearance {

    /// Text color of the text inside the HUD
    public var textColor = UIColor.black
    
    /// The background color of the view where the HUD is presented
    public var backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    /// The background color of the particle effect view
    public var particleEffectBackgroundColor = UIColor.white
    
    /// The background color of the HUD view
    public var foregroundColor = UIColor.white
    
    /// The color of the icon in the HUD
    public var iconColor = UIColor.gray
    
    /// The color of the loading indicator
    public var loadingActivityIndicatorColor = UIColor.gray
    
    /// The type of blur effect in background view when the HUD is presented
    public var backgroundBlurEffect: BlurEffect = .none
    
    /// The corner radius of the HUD
    public var cornerRadius: Double = 10
    
    /// Enables/disables shadow effect around the HUD
    public var shadow: Bool = true
    
    /// The HUD fade in duration
    public var animateInTime: TimeInterval = 0.7
    
    /// The HUD fade out duration
    public var animateOutTime: TimeInterval = 0.7
    
    /// The default display duration for the HUD
    public var defaultDurationTime: Double = 2.0
    
    /// Enables/disables removal of the HUD if the user taps on the screen
    public var cancelableOnTouch = false
    
    /// The title font name of text in the HUD
    public var titleFontName: String = "Helvetica-Bold"
    
    /// The info message font name of text in the HUD
    public var messageFontName: String = "Helvetica"
    
    /// The title font size of text in the HUD
    public var titleFontSize: CGFloat = 20
    
    /// The info message font size of text in the HUD
    public var messageFontSize: CGFloat = 13
    
    /// The HUD size
    public var hudSquareSize: CGFloat = 144
    
    /// The width of the icon inside the HUD
    public var iconWidth: CGFloat = 48
    
    /// The height of the icon inside the HUD
    public var iconHeight: CGFloat = 48
    
}

public enum HUDAppearanceShadow {
    case on()
    case off
}

public struct HUDAppearance_new {
    
    private init() {}
    
    /// Text color of the text inside the HUD
    public static var textColor = UIColor.black
    
    /// The background color of the view where the HUD is presented
    public static var backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    /// The background color of the HUD view
    public static var foregroundColor = UIColor.white
    
    /// The color of the loading indicator
    public static var loadingActivityIndicatorColor = UIColor.gray
    
    /// The corner radius of the HUD
    public static var cornerRadius: CGFloat = 10
    
    /// Enables/disables shadow effect around the HUD
    public static var shadow: Bool = true
    
    public static var shadowColor: UIColor = UIColor.black
    
    public static var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    
    public static var shadowRadius: CGFloat = 6.0
    
    public static var shadowOpacity: Float = 0.15
    
    /// Enables/disables removal of the HUD if the user taps on the screen
    public static var cancelableOnTouch = true // false
    
    /// The info message font in the HUD
    public static var messageFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    /// The title font in the HUD
    public static var titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    /// The size of the icon inside the HUD
    public static var iconSize = CGSize(width: 48, height: 48)
    
    /// The HUD size
    public static var hudSize = CGSize(width: 144, height: 144)
    
    /// The HUD fade in duration
    public static var animateInTime: TimeInterval = 0.7
    
    /// The HUD fade out duration
    public static var animateOutTime: TimeInterval = 0.7
}
