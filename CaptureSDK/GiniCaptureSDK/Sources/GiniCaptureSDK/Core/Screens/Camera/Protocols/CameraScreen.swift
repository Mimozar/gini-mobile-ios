//
//  CameraScreen.swift
//  
//
//  Created by Krzysztof Kryniecki on 12/09/2022.
//  Copyright © 2022 Gini GmbH. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol CameraScreen: CameraTips where Self: UIViewController {
    func animateToControlsView(imageDocument: GiniImageDocument, completion: (() -> Void)?)
    func setupCamera()
    func addValidationLoadingView() -> UIView
    func replaceCapturedStackImages(with images: [UIImage])
}

@objc public protocol CameraTips {
    func hideCameraOverlay()
    func hideCaptureButton()
    func hideFileImportTip()
    func hideQrCodeTip()
    func showCameraOverlay()
    func showCaptureButton()
    func showFileImportTip()
    func showQrCodeTip()
}

public extension CameraScreen {
    func animateToControlsView(imageDocument: GiniImageDocument) {
        animateToControlsView(imageDocument: imageDocument, completion: nil)
    }
}
