//
//  SettingsViewController+SwitchOptionModel.swift
//  GiniBankSDKExample
//
//  Created by Valentina Iancu on 16.06.23.
//

struct SwitchOptionModel {
	let type: OptionType
	var isSwitchOn: Bool
	
	enum OptionType {
		case openWith
		case qrCodeScanning
		case qrCodeScanningOnly
		case multipage
		case flashToggle
		case flashOnByDefault
		case bottomNavigationBar
		case helpNavigationBarBottomAdapter
		case cameraNavigationBarBottomAdapter
		case reviewNavigationBarBottomAdapter
		case imagePickerNavigationBarBottomAdapter
		case onboardingShowAtLaunch
		case onboardingShowAtFirstLaunch
		case onboardingAlignCornersIllustrationAdapter
		case onboardingLightingIllustrationAdapter
		case onboardingQRCodeIllustrationAdapter
		case onboardingMultiPageIllustrationAdapter
		case onboardingNavigationBarBottomAdapter
		case customOnboardingPages
		case onButtonLoadingIndicator
		case customLoadingIndicator
		case shouldShowSupportedFormatsScreen
		case customMenuItems
		case customNavigationController
		case shouldShowDragAndDropTutorial // just for iPad
		case digitalInvoiceOnboardingIllustrationAdapter
		case digitalInvoiceHelpNavigationBarBottomAdapter
		case digitalInvoiceOnboardingNavigationBarBottomAdapter
		case digitalInvoiceNavigationBarBottomAdapter
		case primaryButtonConfiguration
		case secondaryButtonConfiguration
		case transparentButtonConfiguration
		case cameraControlButtonConfiguration
		case addPageButtonConfiguration
		case returnAssistantEnabled
		case enableReturnReasons
		case customDocumentValidations
		case giniErrorLoggerIsOn
		case debugModeOn
		
		var title: String {
			switch self {
			case .openWith:
				return "Open with"
			case .qrCodeScanning:
				return "QR code scanning"
			case .qrCodeScanningOnly:
				return "QR code scanning only"
			case .multipage:
				return "Multipage"
			case .flashToggle:
				return "Flash toggle"
			case .flashOnByDefault:
				return "Flash ON by default"
			case .bottomNavigationBar:
				return "Bottom navigation bar"
			case .helpNavigationBarBottomAdapter:
				return "Custom bottom navigation bar on the help screens"
			case .cameraNavigationBarBottomAdapter:
				return "Custom bottom navigation bar on the camera screen"
			case .reviewNavigationBarBottomAdapter:
				return "Custom bottom navigation bar on the review screen"
			case .imagePickerNavigationBarBottomAdapter:
				return "Custom bottom navigation bar on the image picker screen"
			case .onboardingShowAtLaunch:
				return "Onboarding screens at launch"
			case .onboardingShowAtFirstLaunch:
				return "Onboarding screens at first launch"
			case .onboardingAlignCornersIllustrationAdapter:
				return "Onboarding `align corners` page custom illustration"
			case .onboardingLightingIllustrationAdapter:
				return "Onboarding `lighting` page custom illustration"
			case .onboardingQRCodeIllustrationAdapter:
				return "Onboarding `QR code` page custom illustration"
			case .onboardingMultiPageIllustrationAdapter:
				return "Onboarding `multi page` page custom illustration"
			case .onboardingNavigationBarBottomAdapter:
				return "Onboarding custom bottom navigation bar"
			case .customOnboardingPages:
				return "Custom onboarding pages"
			case .onButtonLoadingIndicator:
				return "Buttons custom loading indicator"
			case .customLoadingIndicator:
				return "Screen custom loading indicator"
			case .shouldShowSupportedFormatsScreen:
				return "Supported formats screen"
			case .customMenuItems:
				return "Help custom menu items"
			case .customNavigationController:
				return "Custom navigation controller"
			case .shouldShowDragAndDropTutorial:
				return "Drag and drop tutorial"
			case .digitalInvoiceOnboardingIllustrationAdapter:
				return "Digital invoice onboarding custom illustration"
			case .digitalInvoiceHelpNavigationBarBottomAdapter:
				return "Digital invoice help bottom navigation bar"
			case .digitalInvoiceOnboardingNavigationBarBottomAdapter:
				return "Digital invoice onboarding bottom navigation bar"
			case .digitalInvoiceNavigationBarBottomAdapter:
				return "Digital invoice bottom navigation bar"
			case .primaryButtonConfiguration:
				return "Custom primary button"
			case .secondaryButtonConfiguration:
				return "Custom secondary button"
			case .transparentButtonConfiguration:
				return "Custom transparent button"
			case .cameraControlButtonConfiguration:
				return "Custom camera control button"
			case .addPageButtonConfiguration:
				return "Custom add page button"
			case .returnAssistantEnabled:
				return "Return Assistant feature"
			case .enableReturnReasons:
				return "Return reasons dialog"
			case .customDocumentValidations:
				return "Add custom document validations"
			case .giniErrorLoggerIsOn:
				return "Gini error logger"
			case .debugModeOn:
				return "Debug mode"
			}
		}
		
		var message: String? {
			switch self {
			case .qrCodeScanningOnly:
				return "This will work if the `QR code scanning` switch is also enabled."
			case .flashOnByDefault:
				return "This will work if the `flash toggle` switch is also enabled."
			case .customOnboardingPages:
				return "This will work if the `onboarding show at launch` switch is also enabled."
			case .onButtonLoadingIndicator:
				return "Set custom loading indicator on the buttons which support loading."
			case .customLoadingIndicator:
				return "Show a custom loading indicator on the document analysis screen."
			case .shouldShowSupportedFormatsScreen:
				return "Show the supported formats screen in the Help menu."
			case .shouldShowDragAndDropTutorial:
				return "Show drag and drop tutorial step in Help menu > How to import option."
			case .onboardingShowAtFirstLaunch:
				return "Overwrites `Onboarding screens at launch` for the first launch."
			case .onboardingNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if both `Bottom navigation bar` and `Return Assistant feature` are also enabled."
			case .digitalInvoiceHelpNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if both `Bottom navigation bar` and `Return Assistant feature` are also enabled."
			case .digitalInvoiceOnboardingNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if both `Bottom navigation bar` and `Return Assistant feature` are also enabled."
			case .digitalInvoiceNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if both `Bottom navigation bar` and `Return Assistant feature` are also enabled."
			case .helpNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if `Bottom navigation bar` is also enabled."
			case .cameraNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if `Bottom navigation bar` is also enabled."
			case .reviewNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if `Bottom navigation bar` is also enabled."
			case .imagePickerNavigationBarBottomAdapter:
				return "The custom bottom navigation bar is shown if `Bottom navigation bar` is also enabled."
			case .primaryButtonConfiguration:
				return "Primary button on different screens, e.g: `Onboarding`, `Digital Invoice Onboarding`, `Error`, etc."
			case .secondaryButtonConfiguration:
				return "Secondary button on different screens: `No Results`, `Error`."
			case .transparentButtonConfiguration:
				return "Transparent button used on `Onboarding` screen in the bottom navigation bar."
			case .cameraControlButtonConfiguration:
				return "Camera control button used for `Browse` and `Flash` buttons on `Camera` screen."
			case .addPageButtonConfiguration:
				return "Add page button used on `Review `screen."
			case .returnAssistantEnabled:
				return "Present a digital representation of the invoice"
			default:
				return nil
			}
		}
	}
}
