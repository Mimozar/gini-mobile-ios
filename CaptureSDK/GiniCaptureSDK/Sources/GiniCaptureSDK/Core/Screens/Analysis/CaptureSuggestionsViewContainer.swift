//
//  CaptureSuggestionsViewContainer.swift
//  
//
//  Created by David Vizaknai on 23.08.2022.
//

import UIKit

final class CaptureSuggestionsViewContainer: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    fileprivate func configureView() {
        let configuration = GiniConfiguration.shared

        backgroundColor = GiniColor(light: UIColor.GiniCapture.light1, dark: UIColor.GiniCapture.dark3).uiColor()
        layer.cornerRadius = 16

        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = configuration.textStyleFonts[.calloutBold]
        titleLabel.textColor = GiniColor(light: UIColor.GiniCapture.dark1, dark: UIColor.GiniCapture.light1).uiColor()

        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.font = configuration.textStyleFonts[.subheadline]
        descriptionLabel.textColor = UIColor.GiniCapture.dark7
    }

    func configureContent(with image: UIImage?, title: String, description: String) {
        self.imageView.image = image
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
