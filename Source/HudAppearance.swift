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
