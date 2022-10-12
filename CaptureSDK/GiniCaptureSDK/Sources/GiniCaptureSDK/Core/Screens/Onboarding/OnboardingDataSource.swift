//
//  OnboardingPagesDataSource.swift
//  
//
//  Created by Nadya Karaban on 14.09.22.
//

import Foundation
import UIKit
protocol BaseTableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    init(
        configuration: GiniConfiguration
    )
}

protocol BaseCollectionViewDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    init(
        configuration: GiniConfiguration
    )
}

class OnboardingDataSource: NSObject, BaseCollectionViewDataSource {
    private enum OnboadingPageType: Int {
        case alignCorners = 0
        case lightning = 1
        case multipage = 2
        case qrcode = 3
    }
    var currentPage: Int?
    var items: [OnboardingPageNew] = []
    let giniConfiguration: GiniConfiguration
    required init(configuration: GiniConfiguration) {
        giniConfiguration = configuration
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemSections.count
    }
    private func configureCell(cell: OnboardingPageCell, indexPath: IndexPath) {
        let item = itemSections[indexPath.row]
        let image = UIImageNamedPreferred(named: item.imageName)
        let onboardingPageType = OnboadingPageType.init(rawValue: indexPath.row)
        switch onboardingPageType {
        case .alignCorners:
            if let adapter = giniConfiguration.onboardingAlignCornersIllustrationAdapter {
                cell.iconView.illustrationAdapter = adapter
            } else {
                cell.iconView.illustrationAdapter = ImageOnboardingIllustrationAdapter()
                cell.iconView.icon = image
            }
        case .lightning:
            if let adapter = giniConfiguration.onboardingLightingIllustrationAdapter {
                cell.iconView.illustrationAdapter = adapter
            } else {
                cell.iconView.illustrationAdapter = ImageOnboardingIllustrationAdapter()
                cell.iconView.icon = image
            }
        case .multipage:
            if let adapter = giniConfiguration.onboardingMultiPageIllustrationAdapter {
                cell.iconView.illustrationAdapter = adapter
            } else {
                cell.iconView.illustrationAdapter = ImageOnboardingIllustrationAdapter()
                cell.iconView.icon = image
            }
        case .qrcode:
            if let adapter = giniConfiguration.onboardingQRCodeIllustrationAdapter {
                cell.iconView.illustrationAdapter = adapter
            } else {
                cell.iconView.illustrationAdapter = ImageOnboardingIllustrationAdapter()
                cell.iconView.icon = image
            }
        default: fatalError("Unhandled case \(indexPath.row)")
        }

        cell.fullText.text = item.description
        cell.title.text = item.title
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingPageCell.identifier,
                                                         for: indexPath) as? OnboardingPageCell {
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        }
        fatalError("OnboardingPageCell wasn't initialized")
    }
    lazy var itemSections: [OnboardingPageNew] = {
        if let customPages = giniConfiguration.customOnboardingPages {
            return customPages
        } else {
            var sections: [OnboardingPageNew] =
            [
                OnboardingPageNew(imageName: "onboardingFlatPaper", title: NSLocalizedStringPreferredFormat(
                    "ginicapture.onboarding.flatPaper.title",
                    comment: "onboarding flat paper title"), description: NSLocalizedStringPreferredFormat(
                        "ginicapture.onboarding.flatPaper.description",
                        comment: "onboarding flat paper description")),
                OnboardingPageNew(imageName: "onboardingGoodLightning", title: NSLocalizedStringPreferredFormat(
                    "ginicapture.onboarding.goodLightning.title",
                    comment: "onboarding good lightning title"), description: NSLocalizedStringPreferredFormat(
                        "ginicapture.onboarding.goodLightning.description",
                        comment: "onboarding good lightning description"))
            ]
            if giniConfiguration.multipageEnabled {
                sections.append(
                    OnboardingPageNew(imageName: "onboardingMultiPages", title: NSLocalizedStringPreferredFormat(
                        "ginicapture.onboarding.multiPages.title",
                        comment: "onboarding multi pages title"),
                                      description: NSLocalizedStringPreferredFormat(
                                        "ginicapture.onboarding.multiPages.description",
                                        comment: "onboarding multi pages description")))
            }
            if giniConfiguration.qrCodeScanningEnabled {
                sections.append(
                    OnboardingPageNew(imageName: "onboardingQRCode", title: NSLocalizedStringPreferredFormat(
                        "ginicapture.onboarding.qrCode.title",
                        comment: "onboarding qrcode title"), description: NSLocalizedStringPreferredFormat(
                            "ginicapture.onboarding.qrCode.description",
                            comment: "onboarding qrcode description")))
            }
            return sections
        }
    }()

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        let onboardingPageType = OnboadingPageType.init(rawValue: indexPath.row)
        if onboardingPageType == .alignCorners {
            if let adapter = giniConfiguration.onboardingAlignCornersIllustrationAdapter {
                    adapter.pageDidAppear()
                    print("pageDidAppear")
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        let onboardingPageType = OnboadingPageType.init(rawValue: indexPath.row)
        if onboardingPageType == .alignCorners {
            if let adapter = giniConfiguration.onboardingAlignCornersIllustrationAdapter {
                adapter.pageDidDisappear()
                print("pageDidDisappear")
            }
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
