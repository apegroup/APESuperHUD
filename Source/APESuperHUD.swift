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

/**
 Default icons

 - HappyFace: An icon with a smiling face.
 - SadFace: An icon with a sad face.
 - CheckMark: An icon with a standard checkmark.
 - Email: An icon with a letter.
*/
public enum IconType: String {

    case info = "info_icon"
    case happyFace = "happy_face_icon"
    case sadFace = "sad_face_icon"
    case checkMark = "checkmark_icon"
    case email = "email_icon"

}

/**
Layout of the loading indicator

 - Standard: Apple standard spinner loading indicator.
*/
public enum LoadingIndicatorType: Int {
    case standard
}

/**
 Enum for setting language for default messages in the HUD

 - English: English
 */
public enum LanguageType: Int {
    case english
}

public enum Accessory {
	case none
	case loader
	case icon(IconType)
	case image(UIImage)
}

public enum Content {
	case none
	case message(String)
	case messages([String])
	case title(String?, message: String?)
	case funny(LanguageType)
}

public enum Autoremove {
	case no
	case appearance
	case after(Double)
}

public enum PresentationStatus {
	case presented
	case updated
	case removed
}

public class APESuperHUD {

    /// Property for setting up the HUD appearance
    public static var appearance = HUDAppearance()

    // MARK: API Remove

    /**
     Removes the HUD.

     - parameter animated: If the remove action should be animated or not.
     - parameter presentingView: The view that the HUD is located in.
     - parameter completion: Will be trigger when the HUD is removed.
    */
    public static func removeHUD(animated: Bool, presentingView: UIView, completion: (() -> Void)? = nil) {
        if let hudView = getHudView(presentingView: presentingView) {
            hudView.removeHud(animated: animated, onDone: { _ in
                completion?()
            })
        }
    }


	/// Show or update the HUD.
	///
	/// - Parameters:
	///   - content: Content value
	///   - accessory: Accesssory value
	///   - view: The view that the HUD will be located in.
	///   - autoremove: Will it be autoremoved
	///   - particleEffectFileName: The name of the Sprite Kit particle file in your project that you want to show in the HUD background.
	///   - completion: Will be trigger when the HUD is presented, updated or removed passing status parameter.
	public static func showOrUpdateHUD(with content: Content = .none, having accessory: Accessory = .none, in view: UIView, autoremove: Autoremove = .no, particleEffectFileName: String? = nil, completion: ((PresentationStatus) -> Void)? = nil) {

		let hudView = createHudViewIfNeeded(presentingView: view)
		if let particleEffectFileName = particleEffectFileName {
			hudView.addParticleEffect(sksfileName: particleEffectFileName)
		}

		let isVisible = hudView.isVisible
		hudView.show(content, with: accessory) {
			completion?(isVisible ? .updated : .presented)
		}

		let autoremoveItAfter: (Double) -> Void = { duration in
			DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
				hudView.removeHud(animated: true) {
					completion?(.removed)
				}
			})
		}

		switch autoremove {
		case .after(let timeout):
			autoremoveItAfter(timeout)
		case .appearance:
			autoremoveItAfter(appearance.defaultDurationTime)
		case .no:
			break
		}
	}

    // MARK: - Private functions

    private static func iconImage(imageName: String) -> UIImage? {
        return UIImage(named: imageName, in: Bundle(for: APESuperHUD.self), compatibleWith: nil)
    }

    static func createHudViewIfNeeded(presentingView: UIView) -> HudView {
        if let hudView = getHudView(presentingView: presentingView) {
            return hudView
        }

        let hudView = HudView.create()
        presentingView.addSubview(hudView)

        return hudView
    }

    static func createHudView(presentingView: UIView) -> HudView {
        let hudView = HudView.create()
        presentingView.addSubview(hudView)

        return hudView
    }

    private static func getHudView(presentingView: UIView) -> HudView? {
        for subview in presentingView.subviews {
            if let hudview = subview as? HudView {
                return hudview
            }
        }

        return nil
    }

}
