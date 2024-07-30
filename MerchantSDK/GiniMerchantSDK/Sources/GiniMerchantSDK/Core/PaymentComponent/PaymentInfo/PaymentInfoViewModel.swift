//
//  PaymentInfoViewModel.swift
//  GiniMerchantSDK
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit
import GiniUtilites
import GiniHealthAPILibrary

struct FAQSection {
    let title: String
    var description: NSAttributedString
    var isExtended: Bool
}

final class PaymentInfoViewModel {
    let configuration: PaymentInfoConfiguration
    let strings: PaymentInfoStrings
    var paymentProviders: PaymentProviders
    let poweredByGiniViewModel: PoweredByGiniViewModel

    var payBillsDescriptionAttributedText: NSMutableAttributedString = NSMutableAttributedString()
    var payBillsDescriptionLinkAttributes: [NSAttributedString.Key: Any]
    var questions: [FAQSection] = []
    
    init(paymentProviders: PaymentProviders, 
         configuration: PaymentInfoConfiguration,
         strings: PaymentInfoStrings,
         poweredByGiniConfiguration: PoweredByGiniConfiguration,
         poweredByGiniStrings: PoweredByGiniStrings) {
        self.paymentProviders = paymentProviders
        self.configuration = configuration
        self.strings = strings
        self.poweredByGiniViewModel = PoweredByGiniViewModel(configuration: poweredByGiniConfiguration, strings: poweredByGiniStrings)

        payBillsDescriptionLinkAttributes = [.foregroundColor: configuration.linksFont]

        configurePayBillsGiniLink()
        setupQuestions()
    }
    
    private func setupQuestions() {
        for index in 1 ... Constants.numberOfQuestions {
            let answerAttributedString = answerWithAttributes(answer: NSLocalizedStringPreferredFormat("gini.merchant.paymentcomponent.paymentinfo.questions.answer.\(index)",
                                                                                                       comment: "Answers description"))
            let questionSection = FAQSection(title: NSLocalizedStringPreferredFormat("gini.merchant.paymentcomponent.paymentinfo.questions.question.\(index)",
                                                                                          comment: "Questions titles"),
                                             description: textWithLinks(linkFont: configuration.linksFont,
                                                                             attributedString: answerAttributedString),
                                                  isExtended: false)
            questions.append(questionSection)
        }
    }
    
    private func configurePayBillsGiniLink() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.payBillsDescriptionLineHeight
        paragraphStyle.paragraphSpacing = Constants.payBillsParagraphSpacing
        payBillsDescriptionAttributedText = NSMutableAttributedString(string: strings.payBillsDescriptionText,
                                                                      attributes: [.paragraphStyle: paragraphStyle,
                                                                                   .font: configuration.payBillsDescriptionFont,
                                                                                   .foregroundColor: configuration.payBillsTitleColor])
        payBillsDescriptionAttributedText = textWithLinks(linkFont: configuration.giniFont,
                                                          attributedString: payBillsDescriptionAttributedText)
    }
    
    private func answerWithAttributes(answer: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.answersLineHeight
        paragraphStyle.paragraphSpacing = Constants.answersParagraphSpacing
        let answerAttributedText = NSMutableAttributedString(string: answer,
                                                             attributes: [.font: configuration.answersFont, .paragraphStyle: paragraphStyle])
        return answerAttributedText
    }
    
    private func textWithLinks(linkFont: UIFont, attributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let attributedString = attributedString
        let giniRange = (attributedString.string as NSString).range(of: strings.giniWebsiteText)
        attributedString.addLinkToRange(link: strings.giniURLText,
                                        range: giniRange,
                                        linkFont: linkFont,
                                        textToRemove: Constants.linkTextToRemove)
        let privacyPolicyRange = (attributedString.string as NSString).range(of: strings.answerPrivacyPolicyText)
        attributedString.addLinkToRange(link: strings.privacyPolicyURLText,
                                        range: privacyPolicyRange,
                                        linkFont: linkFont,
                                        textToRemove: Constants.linkTextToRemove)
        return attributedString
    }

    func infoAnswerCellModel(at index: Int) -> PaymentInfoAnswerTableViewModel {
        PaymentInfoAnswerTableViewModel(answerAttributedText: questions[index].description, 
                                        answerTextColor: configuration.answerCellTextColor,
                                        answerLinkColor: configuration.answerCellLinkColor)
    }

    func infoQuestionHeaderViewModel(at index: Int) -> PaymentInfoQuestionHeaderViewModel {
        PaymentInfoQuestionHeaderViewModel(titleText: questions[index].title, 
                                           titleFont: configuration.questionHeaderFont,
                                           titleColor: configuration.questionHeaderTitleColor,
                                           extendedIcon: questions[index].isExtended ? configuration.questionHeaderMinusIcon : configuration.questionHeaderPlusIcon)
    }

    func infoBankCellModel(at index: Int) -> PaymentInfoBankCollectionViewCellModel {
        PaymentInfoBankCollectionViewCellModel(bankImageIconData: paymentProviders[index].iconData,
                                               borderColor: configuration.bankCellBorderColor)
    }
}

extension PaymentInfoViewModel {
    private enum Constants {
        static let numberOfQuestions = 6
        
        static let payBillsDescriptionLineHeight = 1.32
        static let payBillsParagraphSpacing = 10.0
        
        static let answersLineHeight = 1.32
        static let answersParagraphSpacing = 10.0
        
        static let linkTextToRemove = "[LINK]"
    }
}
