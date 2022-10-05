//
//  CameraBottomNavigationBar.swift
//  
//
//  Created by Krzysztof Kryniecki on 26/09/2022.
//

import UIKit

class CameraBottomNavigationBar: UIView {

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func setupView() {
        let configuration = GiniConfiguration.shared
        rightButton.setTitle(NSLocalizedStringPreferredFormat(
            "ginicapture.navigationbar.camera.help",
            comment: "Camera Help Button"), for: .normal)
        rightButton.titleLabel?.font = configuration.textStyleFonts[.body]
        rightButton.setTitleColor(
            GiniColor(
                light: UIColor.GiniCapture.light1,
                dark: UIColor.GiniCapture.light1
            ).uiColor(),
            for: .normal)
        rightButton.tintColor = GiniColor(
            light: UIColor.GiniCapture.light1,
            dark: UIColor.GiniCapture.light1
        ).uiColor()
        leftButton.setTitle("", for: .normal)
        leftButton.setImage(
            UIImageNamedPreferred(named: "arrowBack") ?? UIImage(),
            for: .normal)
        backgroundColor = GiniColor(
            light: UIColor.GiniCapture.dark2,
            dark: UIColor.GiniCapture.dark2
        ).uiColor()
    }
}
