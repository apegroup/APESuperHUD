//
//  HUDType.swift
//  APESuperHUD
//
//  Created by Daniel Nilsson on 2018-02-23.
//  Copyright © 2018 Apegroup. All rights reserved.
//

import Foundation

public enum HUDStyle {
    case icon(image: UIImage, duration: TimeInterval)
    case loadingIndicator(type: LoadingIndicatorType)
}
