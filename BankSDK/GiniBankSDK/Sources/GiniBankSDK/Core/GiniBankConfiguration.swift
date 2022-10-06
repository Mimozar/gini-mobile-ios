//
// GiniBankConfiguration.swift
// GiniBank
//
//  Created by Nadya Karaban on 11.03.21.
//

import UIKit
import GiniCaptureSDK

public final class GiniBankConfiguration: NSObject {
    
    /**
     Singleton to make configuration internally accessible in all classes of the Gini Bank SDK.
     */
    public static var shared = GiniBankConfiguration()
    
    /**
     Indicates whether the Return Assistant feature is enabled or not. In case of `true`,
     the user will be presented with a digital representation of their invoice where they
     can see individual line items and are able to amend them or choose to not to pay for them.
    */
    @objc public var returnAssistantEnabled = true
    
    /**
     Returns a `GiniBankConfiguration` instance which allows to set individual configurations
     to change the look and feel of the Gini Bank SDK.
     
     - returns: Instance of `GiniBankConfiguration`.
     */
    public override init() {}
    
    // MARK: General options
    
    /**
     Sets custom validations that can be done apart from the default ones (file size, file type...).
     It should throw a `CustomDocumentValidationError` error.
     */
    @objc public var customDocumentValidations: ((GiniCaptureDocument) -> CustomDocumentValidationResult) = { _ in
        return CustomDocumentValidationResult.success()
    }
    
    /**
     Can be turned on during development to unlock extra information and to save captured images to camera roll.
     
     - warning: Should never be used outside of a development enviroment.
     */
    @objc public var debugModeOn = false
    
    /**
     Used to handle all the logging messages in order to log them in a different way.
     */
    @objc public var logger: GiniLogger = GiniConfiguration().logger
    
    /**
     Indicates whether the multipage feature is enabled or not. In case of `true`,
     multiple pages can be processed, showing a different review screen when capturing.
     */
    @objc public var multipageEnabled = false
    
    /**
     Sets the custom navigation view controller as a root view controller for Gini Bank SDK screens.
    */
    @objc public var customNavigationController : UINavigationController? = nil
    
    /**
     Sets the tint color of the navigation bar in all screens of the Gini Bank SDK to
     the globally specified color or to a default color.
    */
    @objc public var navigationBarTintColor = UINavigationBar.appearance().barTintColor ?? GiniColor(light: UIColor.GiniBank.light1, dark: UIColor.GiniBank.dark2).uiColor()
    
    /**
     Sets the tint color of all navigation items in all screens of the Gini Bank SDK to
     the globally specified color.
     
     - note: Screen API only.
     */
    @objc public var navigationBarItemTintColor = UINavigationBar.appearance().tintColor
    
    /**
     Sets the font of all navigation items in all screens of the Gini Bank SDK to
     the globally specified font or a default font.
     
     - note: Screen API only.
     */
    @objc public var navigationBarItemFont = UIBarButtonItem.appearance()
        .titleTextAttributes(for: .normal).dictionary?[NSAttributedString.Key.font.rawValue] as? UIFont ??
        UIFont.systemFont(ofSize: 16, weight: .bold)
    
    /**
     Sets the title color in the navigation bar in all screens of the Gini Bank SDK to
     the globally specified color or to a default color.
     
     - note: Screen API only.
     */
    @objc public var navigationBarTitleColor = UINavigationBar
        .appearance()
        .titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor ?? .white
    
    /**
     Sets the title font in the navigation bar in all screens of the Gini Bank SDK to
     the globally specified font or to a default font.

     - note: Screen API only.
     */
    @objc public var navigationBarTitleFont = UINavigationBar
        .appearance()
        .titleTextAttributes?[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    
    /**
     Sets the tint color of the UIDocumentPickerViewController navigation bar.
     
     - note: Use only if you have a custom `UIAppearance` for your UINavigationBar
     - note: Only iOS >= 11.0
     */
    @objc public var documentPickerNavigationBarTintColor: UIColor?
    
    /**
     Sets the background color of an informal notice. Notices are small pieces of
     information appearing underneath the navigation bar.
     */
    @objc public var noticeInformationBackgroundColor = UIColor.black
    
    /**
     Sets the text color of an informal notice. Notices are small pieces of
     information appearing underneath the navigation bar.
     */
    @objc public var noticeInformationTextColor = UIColor.white
    
    /**
     Sets the background color of an error notice. Notices are small pieces of
     information appearing underneath the navigation bar.
     */
    @objc public var noticeErrorBackgroundColor = UIColor.red
    
    /**
     Sets the text color of an error notice. Notices are small pieces of
     information appearing underneath the navigation bar.
     */
    @objc public var noticeErrorTextColor = UIColor.white
    
    /**
     Indicates whether the open with feature is enabled or not. In case of `true`,
     a new option with the open with tutorial wil be shown in the Help menu.
     */
    @objc public var openWithEnabled = false
    
    /**
     Indicates whether the QR Code scanning feature is enabled or not.
     */
    @objc public var qrCodeScanningEnabled = false
    
    /**
     Indicates the status bar style in the Gini Bank SDK.
     
     - note: If `UIViewControllerBasedStatusBarAppearance` is set to `false` in the `Info.plist`,
     it may not work in future versions of iOS since the `UIApplication.setStatusBarStyle` method was
     deprecated on iOS 9.0.
     */
    @objc public var statusBarStyle = UIStatusBarStyle.lightContent
    
    // MARK: Camera options
    
    /**
     Sets the color of camera preview corner guides.
     */
    @objc public var cameraPreviewCornerGuidesColor = UIColor.white
    
    /**
     Sets the background color of camera container view.
     */
    @objc public var cameraContainerViewBackgroundColor = GiniColor(light: .black, dark: .black)
    
    /**
     Sets the color of camera preview frame.
     */
    @objc public var cameraPreviewFrameColor = GiniColor(light: UIColor(white: 0.0, alpha: 0.7), dark: UIColor(white: 0.0, alpha: 0.7))
    
    /**
     Sets the background color of camera buttons view.
     */
    @objc public var cameraButtonsViewBackgroundColor = GiniColor(light: .black, dark: .black)
    
    /**
     Set the types supported by the file import feature. `GiniCaptureImportFileTypes.none` by default.
     */
    @objc public var fileImportSupportedTypes = GiniConfiguration.GiniCaptureImportFileTypes.none
    
    /**
     Sets the background color of the new file import button hint.
     */
    @objc public var fileImportToolTipBackgroundColor = UIColor.white
    
    /**
     Sets the text color of the new file import button hint.
     */
    @objc public var fileImportToolTipTextColor = UIColor.black
    
    /**
     Sets the close button color of the new file import button hint.
     */
    @objc public var fileImportToolTipCloseButtonColor = Colors.Gini.grey
    
    /**
     Sets the background style when the tooltip is shown.
     */
    public var toolTipOpaqueBackgroundStyle: OpaqueViewStyle {
        
        set {
            _toolTipOpaqueBackgroundStyle = newValue
        }
        
        get {
            
            if let setValue = _toolTipOpaqueBackgroundStyle {
                return setValue
            } else {
                
                if #available(iOS 13.0, *) {
                    return .blurred(style: .regular)
                } else {
                    return .blurred(style: .dark)
                }
            }
        }
    }
    
    private var _toolTipOpaqueBackgroundStyle: OpaqueViewStyle?
    
    /**
     Sets the text color of the item selected background check.
     */
    @objc public var galleryPickerItemSelectedBackgroundCheckColor = Colors.Gini.blue
    
    /**
     Sets the background color for gallery screen.
     */
    @objc public var galleryScreenBackgroundColor = GiniColor(light: .black, dark: .black)
    
    /**
     Indicates whether the flash toggle should be shown in the camera screen.
     */
    @objc public var flashToggleEnabled = false
    
    /**
     When the flash toggle is enabled, this flag indicates if the flash is on by default.
     */
    @objc public var flashOnByDefault = true
    
    /**
     Sets the color of the captured images stack indicator label
     */
    @objc public var imagesStackIndicatorLabelTextcolor: UIColor = Colors.Gini.blue
    
    /**
     Sets the close button text in the navigation bar on the camera screen.
     
     - note: Screen API only.
     */
    @objc public var navigationBarCameraTitleCloseButton = ""
    
    /**
     Sets the help button text in the navigation bar on the camera screen.
     
     - note: Screen API only.
     */
    @objc public var navigationBarCameraTitleHelpButton = ""
    
    /**
     Sets the text color of the QR Code popup button.
     */
    @objc public var qrCodePopupButtonColor = Colors.Gini.blue
    
    /**
     Sets the text color of the QR Code popup label.
     */
    @objc public var qrCodePopupTextColor = GiniColor(light: .black, dark: .white)
    
    /**
     Sets the text color of the QR Code popup background.
     */
    @objc public var qrCodePopupBackgroundColor = GiniColor(light: .white, dark: UIColor.from(hex: 0x1c1c1e))
    
    // MARK: Onboarding screens

    /**
     Sets the continue button text in the navigation bar on the onboarding screen.
     
     - note: Screen API only.
     */
    @objc public var navigationBarOnboardingTitleContinueButton = ""
    
    /**
     Sets the color of the page controller's page indicator items.
     */
    @objc public var onboardingPageIndicatorColor = GiniColor(light: .white, dark: .white)
    
    /**
     Sets the color of the page controller's current page indicator item.
     */
    @objc public var onboardingCurrentPageIndicatorColor = GiniColor(light: .white, dark: .white)
    
    /**
     Sets alpha to the color of the page controller's current page indicator item.
     */
    @objc public var onboardingCurrentPageIndicatorAlpha: CGFloat = 0.2
    
    /**
     Indicates whether the onboarding screen should be presented at each start of the Gini Bank SDK.
     
     - note: Screen API only.
     */
    @objc public var onboardingShowAtLaunch = false
    
    /**
     Indicates whether the onboarding screen should be presented at the first
     start of the Gini Bank SDK. It is advised to do so.
     
     - note: Overwrites `onboardingShowAtLaunch` for the first launch.
     - note: Screen API only.
     */
    @objc public var onboardingShowAtFirstLaunch = true
    
    /**
     Sets the color ot the text for all onboarding pages.
     */
    @objc public var onboardingTextColor = GiniColor(light: .white, dark: .white)
    
    /**
     Sets the background color for all onboarding pages.
     */
        
    @objc public var onboardingScreenBackgroundColor = GiniColor(light: .black, dark: .black)
    
    /**
     All onboarding pages which will be presented in a horizontal scroll view to the user.
     By default the Gini Bank SDK comes with three pages advising the user to keep the
     document flat, hold the device parallel and capture the whole document.
     
     - note: Any array of views can be passed, but for your convenience we provide the `GINIOnboardingPage` class.
     */
    @objc public var onboardingPages: [UIView] {
        get {
            if let pages = onboardingCustomPages {
                return pages
            }
            guard let page1 = OnboardingPage(imageNamed: "onboardingPage1",
                                             text: .localized(resource: OnboardingStrings.onboardingFirstPageText),
                                             rotateImageInLandscape: true),
                let page2 = OnboardingPage(imageNamed: "onboardingPage2",
                                           text: .localized(resource: OnboardingStrings.onboardingSecondPageText)),
                let page3 = OnboardingPage(imageNamed: "onboardingPage3",
                                           text: .localized(resource: OnboardingStrings.onboardingThirdPageText)),
                let page4 = OnboardingPage(imageNamed: "onboardingPage5",
                                           text: .localized(resource: OnboardingStrings.onboardingFifthPageText)) else {
                    return [UIView]()
            }
            
            onboardingCustomPages = [page1, page2, page3, page4]
            if let ipadTipPage = OnboardingPage(imageNamed: "onboardingPage4",
                                                text: .localized(resource: OnboardingStrings.onboardingFourthPageText)),
                UIDevice.current.isIpad {
                onboardingCustomPages?.insert(ipadTipPage, at: 0)
            }
            return onboardingCustomPages!
        }
        set {
            self.onboardingCustomPages = newValue
        }
    }
    
    fileprivate var onboardingCustomPages: [UIView]?
    
    /**
     Enable/disable the bottom navigation bar.
     */
    public var bottomNavigationBarEnabled: Bool = false
    
    /**
      * Set an adapter implementation to show a custom bottom navigation bar on the camera screen.
     */
    public var cameraNavigationBarBottomAdapter: CameraBottomNavigationBarAdapter?
    
    /**
      * Set an adapter implementation to show a custom bottom navigation bar on the onboarding screen.
     */
    public var onboardingNavigationBarBottomAdapter: OnboardingNavigationBarBottomAdapter?

    /**
     Sets the back button text in the navigation bar on the review screen. Use this if you only want to show the title.
     
     - note: Screen API only.
     */
    @objc public var navigationBarReviewTitleBackButton = ""
    
    /**
     Sets the close button text in the navigation bar on the review screen. Use this if you only want to show the title.
     
     - note: Screen API only.
     */
    @objc public var navigationBarReviewTitleCloseButton = ""
    
    /**
     Sets the continue button text in the navigation bar on the review screen.
     
     - note: Screen API only.
     */
    @objc public var navigationBarReviewTitleContinueButton = ""
    
    /**
     Sets the background color of the bottom section on the review screen containing the rotation button.
     
     - note: Background will have a 20% transparency, to have enough space for the document image on smaller devices.
     */
    @objc public var reviewBottomViewBackgroundColor = UIColor.black
    
    /**
     Sets the font of the text appearing at the bottom of the review screen.
     */
    @objc public var reviewTextBottomFont = UIFont.systemFont(ofSize: 12, weight: .thin)
    
    /**
     Sets the color of the text appearing at the bottom of the review screen.
     */
    @objc public var reviewTextBottomColor = UIColor.white
    
    // MARK: Multipage options
    
    /**
     Sets the color of the pages container and toolbar.
     */
    @objc public var multipagePagesContainerAndToolBarColor = GiniColor(light: Colors.Gini.pearl, dark: UIColor.from(hex: 0x1c1c1c))
    
    @objc private var _multipagePagesContainerAndToolBarColor: UIColor?
    
    /**
     Sets the color of the circle indicator.
     */
    @objc public var indicatorCircleColor = GiniColor(light: Colors.Gini.pearl, dark: .lightGray)
    
    /**
     Sets the tint color of the toolbar items.
     */
    @objc public var multipageToolbarItemsColor = Colors.Gini.blue
    
    /**
     Sets the tint color of the page indicator.
     */
    @objc public var multipagePageIndicatorColor = Colors.Gini.blue
    
    /**
     Sets the background color of the page selected indicator.
     */
    @objc public var multipagePageSelectedIndicatorColor = Colors.Gini.blue
    
    /**
     Sets the background color of the page background.
     */
    @objc public var multipagePageBackgroundColor = GiniColor(light: .white, dark: UIColor.from(hex: 0x1c1c1e))
    
    @objc private var _multipagePageBackgroundColor: UIColor?
    
    /**
     Sets the tint color of the draggable icon in the page collection cell.
     */
    @objc public var multipageDraggableIconColor = Colors.Gini.veryLightGray

    /**
     Sets the background style when the tooltip is shown in the multipage screen.
     */
    public var multipageToolTipOpaqueBackgroundStyle: OpaqueViewStyle = .blurred(style: .light)
    
    /**
     Sets the background color for the successfull upload icon.
     */
    public var multipagePageSuccessfullUploadIconBackgroundColor = Colors.Gini.springGreen
    
    /**
     Sets the background color for the failed upload icon.
     */
    public var multipagePageFailureUploadIconBackgroundColor = Colors.Gini.springGreen
    
    // MARK: Analysis options

    /**
     Sets the back button text in the navigation bar on the analysis screen. Use this if you only want to show the title.
     
     - note: Screen API only.
     */
    @objc public var navigationBarAnalysisTitleBackButton = ""
    
    // MARK: Help screens
    
    /**
     Sets the background color for all help screens.
     */
    @objc public var helpScreenBackgroundColor =  GiniColor(light: Colors.Gini.pearl, dark: UIColor.from(hex: 0x1C1C1C))
    
    /**
     Sets the background color for the cells on help screen.
     */
    @objc public var helpScreenCellsBackgroundColor =  GiniColor(light: Colors.Gini.pearl, dark: UIColor.from(hex: 0x1C1C1C))
    
    /**
     Sets the back button text in the navigation bar on the help menu screen. Use this if you only want to show the title.
     
     - note: Screen API only.
     */
    @objc public var navigationBarHelpMenuTitleBackToCameraButton = ""
    
    /**
     Sets the back button text in the navigation bar on the help screen. Use this if you only want to show the title.
     
     - note: Screen API only.
     */
    @objc public var navigationBarHelpScreenTitleBackToMenuButton = ""
    
    /**
     Indicates whether the supported format screens should be shown. In case of `false`,
     the option won't be shown in the Help menu.
     */
    @objc public var shouldShowSupportedFormatsScreen = true
    
    // MARK: Supported formats
    
    /**
     Sets the color of the unsupported formats icon background to the specified color.
     */
    @objc public var nonSupportedFormatsIconColor = Colors.Gini.crimson
    
    /**
     Sets the color of the supported formats icon background to the specified color.
     */
    @objc public var supportedFormatsIconColor = Colors.Gini.paleGreen
    
    // MARK: Open with tutorial options
    
    /**
     Sets the text of the app name for the Open with tutorial texts.
     */
    @objc public var openWithAppNameForTexts = Bundle.main.appName
    
    /**
     Sets the color of the step indicator for the Open with tutorial.
     */
    @objc public var stepIndicatorColor = Colors.Gini.blue
    
    // MARK: No results options
    
    /**
     Sets the color of the bottom button to the specified color.
     */
    @objc public var noResultsBottomButtonColor = Colors.Gini.blue
    
    /**
     Sets the text color of the bottom button to the specified color.
     */
    @objc public var noResultsBottomButtonTextColor = GiniColor.init(light: .white, dark: .white)
    
    /**
     Sets the corner radius of the bottom button.
     */
    @objc public var noResultsBottomButtonCornerRadius: CGFloat = 0.0
    
    /**
     Sets the color of the warning container background to the specified color.
     */
    @objc public var noResultsWarningContainerIconColor = Colors.Gini.rose
    
    // MARK: Albums screen
    
    /**
     Sets the text color for the select more photos button on the albums screen.
     */
    @objc public var albumsScreenSelectMorePhotosTextColor =  GiniColor(light: Colors.Gini.blue, dark: Colors.Gini.blue)
    
    /**
     Sets if the Drag&Drop step should be shown in the "Open with" tutorial.
     */
    @objc public var shouldShowDragAndDropTutorial = true
    
    // Undocumented--Xamarin only
    @objc public var closeButtonResource: PreferredButtonResource?
    @objc public var helpButtonResource: PreferredButtonResource?
    @objc public var backToCameraButtonResource: PreferredButtonResource?
    @objc public var backToMenuButtonResource: PreferredButtonResource?
    @objc public var nextButtonResource: PreferredButtonResource?
    @objc public var cancelButtonResource: PreferredButtonResource?
    
    // MARK: Return Assistant
    
    /**
     Sets the background color for the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenBackgroundColor =  GiniColor(light: .white, dark:.black)
    
    /**
     Sets the text color for the section titles on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenSectionTitleColor =  GiniColor(light: Colors.Gini.blue, dark: Colors.Gini.blue)
    
    /**
     Sets the font for the page title on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenPageTitleFont =  UIFont.systemFont(ofSize: 28, weight: .semibold)
    
    /**
     Sets the font for the section titles on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenSectionTitleFont =  UIFont.systemFont(ofSize: 28, weight: .bold)
    
    /**
     Sets the text color for the instructions on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenInstructionColor =  GiniColor(light: .black, dark:.white)
    
    /**
     Sets the font for the instructions on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenInstructionFont =  UIFont.systemFont(ofSize: 18, weight: .regular)
    
    /**
     Sets the background color for the back button on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenBackButtonColor =  Colors.Gini.blue

    /**
     Sets the title color for the back button on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenBackButtonTitleColor =  GiniColor(light: .white, dark:.black)
    
    /**
     Sets the font for the back button title on the return assistant help screen.
     */
    @objc public var helpReturnAssistantScreenBackButtonTitleFont =  UIFont.systemFont(ofSize: 18, weight: .regular)

        
    // MARK: Digital invoice

    /**
     Sets the color of the active elements on the digital invoice line item cells to the specified color.
     
     Can be overridden by the specific line item tint color customisation options: `lineItemBorderColor`, `digitalInvoiceLineItemEditButtonTintColor`,
     `digitalInvoiceLineItemToggleSwitchTintColor`, `digitalInvoiceLineItemDeleteButtonTintColor`.
     */
    @objc public var lineItemTintColor = Colors.Gini.blue
    
    /**
     Sets the border color on the digital invoice line item cells to the specified color.
     
     Overrides `lineItemTintColor` if not `nil`.
     */
    @objc public var lineItemBorderColor: UIColor? = nil
    
    /**
     Sets the color of the active elements on the digital invoice line item count label to the specified color.
     */
    @objc public var lineItemCountLabelColor = UIColor.lightGray
    
    /**
     Sets the font of the line item name on the digital invoice  line item count label to the specified font.
     */
    @objc public var lineItemCountLabelFont = UIFont.systemFont(ofSize: 16)
    
    /**
     Sets the font of the line item name on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceLineItemNameFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        
    /**
     Sets the font of the line item edit button title on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceLineItemEditButtonTitleFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    /**
     Sets the edit button tint color on the digital invoice screen to the specified color.
     
     Overrides `lineItemTintColor` if not `nil`.
     */
    @objc public var digitalInvoiceLineItemEditButtonTintColor: UIColor? = nil
    
    /**
     Sets the toggle switch tint color on the digital invoice line item cells to the specified color.
     
     Overrides `lineItemTintColor` if not `nil`.
     */
    @objc public var digitalInvoiceLineItemToggleSwitchTintColor: UIColor? = nil
    
    /**
     Sets the delete button tint color on the digital invoice screen to the specified color.
     
     Overrides `lineItemTintColor` if not `nil`.
     */
    @objc public var digitalInvoiceLineItemDeleteButtonTintColor: UIColor? = nil
    
    /**
     Sets the font of the line item label that displays the quantity on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceLineItemQuantityFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    
    /**
     Sets the color of  the line item label that  displays the quantity on the digital invoice line item cells to the specified color.
     */
    @objc public var digitalInvoiceLineItemQuantityColor = GiniColor(light: .black, dark: .white)
    
    /**
     Sets the color of  the line item label that displays the item name on the digital invoice line item cells to the specified color.
     */
    @objc public var digitalInvoiceLineItemNameColor = GiniColor(light: .black, dark: .white)
    
    /**
     Sets the color of  the line item label that displays the price on the digital invoice line item cells to the specified color.
     */
    @objc public var digitalInvoiceLineItemPriceColor = GiniColor(light: .black, dark: .white)
    
    /**
     Sets the font of the main currency unit of the price on the line item of the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceLineItemPriceMainUnitFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    
    /**
    Sets the font of the fractional currency unit of the price on the line item of the digital invoice screen to the specified font.
    */
    @objc public var digitalInvoiceLineItemPriceFractionalUnitFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    
    /**
     Sets the font of the secondary informational message on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceSecondaryMessageTextFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /**
     Sets the color of the secondary message label on the digital invoice line item cells to the specified color.
     */
    @objc public var digitalInvoiceSecondaryMessageTextColor = Colors.Gini.blue
    
    /**
     Sets the background color for digital invoice screen.
     */
    @objc public var digitalInvoiceBackgroundColor =  GiniColor(light: .white, dark: .black)
    
    /**
     Sets the background color for the line items on the digital invoice screen.
     */
    @objc public var digitalInvoiceLineItemsBackgroundColor =  GiniColor(light: .white, dark: .black)
    
    /**
     Sets the disabled color for the line items on the digital invoice screen.
     */
    @objc public var digitalInvoiceLineItemsDisabledColor =  UIColor.gray
    
    /**
     Sets the font of the footer message on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceFooterMessageTextFont = UIFont.systemFont(ofSize: 14)
    
    /**
     Sets the add article button tint color of the footer section on the digital invoice screen.
     */
    @objc public var digitalInvoiceFooterAddArticleButtonTintColor = Colors.Gini.blue
    
    /**
     Sets the font of the add article button of the footer section on the digital invoice screen.
     */
    @objc public var digitalInvoiceFooterAddArticleButtonTitleFont = UIFont.systemFont(ofSize: 18)
    
    /**
     Sets the text color of the footer message on the digital invoice screen.
     */
    @objc public var digitalInvoiceFooterMessageTextColor = GiniColor(light: .darkGray, dark:.white)
    
    /**
     Sets the text color of the items section header on the digital invoice screen.
     */
    @objc public var digitalInvoiceItemsSectionHeaderTextColor = GiniColor(light: .gray, dark:.white)

    /**
     Sets the font of the items section header on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceItemsSectionHeaderTextFont = UIFont.systemFont(ofSize: 12)
    
    /**
     Sets the background color of the digital invoice pay button to the specified color.
     */
    @objc public var payButtonBackgroundColor = Colors.Gini.blue
    
    /**
     Sets the title text color of the digital invoice pay button to the specified color.
     */
    @objc public var payButtonTitleTextColor = UIColor.white
    
    /**
     Sets the title text font of the digital invoice pay button to the specified font.
     */
    @objc public var payButtonTitleFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /**
     Sets the background color of the digital invoice skip button to the specified color.
     */
    @objc public var skipButtonBackgroundColor = UIColor.white
    
    /**
     Sets the title text color of the digital invoice skip button to the specified color.
     */
    @objc public var skipButtonTitleTextColor = Colors.Gini.blue
    
    /**
     Sets the layer border color of the digital invoice skip button to the specified color.
     */
    @objc public var skipButtonBorderColor = Colors.Gini.blue
    
    /**
     Sets the title text font of the digital invoice skip button to the specified font.
     */
    @objc public var skipButtonTitleFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /**
     Sets the font of the addon labels on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceAddonLabelFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    /**
     Sets the font of the total caption label on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceTotalCaptionLabelFont = UIFont.systemFont(ofSize: 32, weight: .semibold)
    
    /**
     Sets the text color of the total caption label on the digital invoice screen.
     */
    @objc public var digitalInvoiceTotalCaptionLabelTextColor = GiniColor(light: .black, dark: .white)
    
    /**
     Sets the font of the total explanation label on the digital invoice screen to the specified font.
     */
    @objc public var digitalInvoiceTotalExplanationLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    /**
     Sets the text color of the explanation label on the digital invoice screen.
     */
    @objc public var digitalInvoiceTotalExplanationLabelTextColor = GiniColor(light: .lightGray, dark: .lightGray)
    
    /**
     Sets the font of the main unit of the addon price labels to the specified font.
     */
    @objc public var digitalInvoiceAddonPriceMainUnitFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    
    /**
     Sets the font of the fractional unit of the addon price labels to the specified font.
     */
    @objc public var digitalInvoiceAddonPriceFractionalUnitFont = UIFont.systemFont(ofSize: 9, weight: .bold)
    
    /**
     Sets the color of the addon price labels in the digital invoice screen to the specified color.
     */
    @objc public var digitalInvoiceAddonPriceColor: UIColor {
        
        set {
            _digitalInvoiceAddonPriceColor = newValue
        }

        get {

            if let setValue = _digitalInvoiceAddonPriceColor {
                return setValue
            } else {

                if #available(iOS 13.0, *) {

                    return .label

                } else {
                    return .black
                }
            }
        }
    }
    
    @objc private var _digitalInvoiceAddonPriceColor: UIColor?
    
    /**
     Sets the color of the addon name labels in the digital invoice screen to the specified color
     */
    @objc public var digitalInvoiceAddonLabelColor = GiniColor(light: .black, dark: .white)
    
    /**
     Sets the color of the total price label in the digital invoice screen to the specified color.
     */
    @objc public var digitalInvoiceTotalPriceColor: UIColor {
        
        set {
            _digitalInvoiceTotalPriceColor = newValue
        }

        get {

            if let setValue = _digitalInvoiceTotalPriceColor {
                return setValue
            } else {

                if #available(iOS 13.0, *) {

                    return .label

                } else {
                    return .black
                }
            }
        }
    }
    
    @objc private var _digitalInvoiceTotalPriceColor: UIColor?
    
    /**
     Sets the font of the digital invoice main unit of the total price label to the specified font.
     */
    @objc public var digitalInvoiceTotalPriceMainUnitFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    
    /**
     Sets the font of the digital invoice fractional unit of the total price label to the specified font.
     */
    @objc public var digitalInvoiceTotalPriceFractionalUnitFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    
    /**
     Sets the font of the content description labels in the line item details view controller to the specified font.
     */
    @objc public var lineItemDetailsDescriptionLabelFont = UIFont.systemFont(ofSize: 12)
    
    /**
     Sets the color of the content description labels in the line item details view controller to the specified color.
     */
    @objc public var lineItemDetailsDescriptionLabelColor: UIColor {
        
        set {
            _lineItemDetailsDescriptionLabelColor = newValue
        }

        get {

            if let setValue = _lineItemDetailsDescriptionLabelColor {
                return setValue
            } else {

                if #available(iOS 13.0, *) {

                    return .secondaryLabel

                } else {
                    return .gray
                }
            }
        }
    }
    
    /**
     Sets the background color for  the line item details view.
     */
    @objc public var lineItemDetailsBackgroundColor =  GiniColor(light: .white, dark: .black)
    
    @objc private var _lineItemDetailsDescriptionLabelColor: UIColor?
    
    /**
     Sets the font of the content labels in the line item details view controller to the specified font.
     */
    @objc public var lineItemDetailsContentLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    
    /**
     Sets the color of the content labels in the line item details view controller to the specified color.
     */
    @objc public var lineItemDetailsContentLabelColor: UIColor {
        
        set {
            _lineItemDetailsContentLabelColor = newValue
        }

        get {

            if let setValue = _lineItemDetailsContentLabelColor {
                return setValue
            } else {

                if #available(iOS 13.0, *) {

                    return .label

                } else {
                    return .black
                }
            }
        }
    }
    
    @objc private var _lineItemDetailsContentLabelColor: UIColor?
    
    /**
     Sets the highlighted underline color of the content labels in the line item details view controller to the specified color
     */
    @objc public var lineItemDetailsContentHighlightedColor: UIColor = Colors.Gini.blue
    
    /**
     Sets the font of the line item details screen main unit of the total price label to the specified font.
     */
    @objc public var lineItemDetailsTotalPriceMainUnitFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    /**
     Sets the font of the line item details screen fractional unit of the total price label to the specified font.
     */
    @objc public var lineItemDetailsTotalPriceFractionalUnitFont = UIFont.systemFont(ofSize: 12, weight: .bold)
    
    /**
     Sets the backgroundColor on the digital invoice onboarding screen.
     */
    @objc public var digitalInvoiceOnboardingBackgroundColor = GiniColor(light: Colors.Gini.blue, dark: Colors.Gini.blue)
    
    /**
     Sets the color on the digital invoice onboarding screen for text labels.
     */
    @objc public var digitalInvoiceOnboardingTextColor = GiniColor(light: UIColor.white, dark: UIColor.white)

    /**
     Sets the font of the first text label on the digital invoice onboarding screen.
     */
    @objc public var digitalInvoiceOnboardingFirstLabelTextFont = UIFont.systemFont(ofSize: 32, weight: .semibold)
    
    /**
     Sets the font of the second text label on the digital invoice onboarding screen.
     */
    @objc public var digitalInvoiceOnboardingSecondLabelTextFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /**
     Sets the backgroundColor  on the digital invoice onboarding screen for done button.
     */
    @objc public var digitalInvoiceOnboardingDoneButtonBackgroundColor = GiniColor(light: UIColor.white, dark: UIColor.white)
    
    /**
     Sets the font of the done button on the digital invoice onboarding screen.
     */
    @objc public var digitalInvoiceOnboardingDoneButtonTextFont = UIFont.systemFont(ofSize: 16, weight: .bold)
    
    /**
     Sets the font of the hide button on the digital invoice onboarding screen.
     */
    @objc public var digitalInvoiceOnboardingHideButtonTextFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /**
     Sets the text color of the done button on the digital invoice onboarding screen.
     */
    @objc public var digitalInvoiceOnboardingDoneButtonTextColor = GiniColor(light: Colors.Gini.blue, dark: Colors.Gini.blue)
    
    /**
     Sets the text color of the done button on the digital invoice onboarding screen.
     */
    @objc public var digitalInvoiceOnboardingHideButtonTextColor = GiniColor(light: .white, dark: .white)
    
    /**
     Sets the background color of the warning info view on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewBackgroundColor = Colors.Gini.blue
    
    /**
     Sets the  chevron image tint color of the warning info view on the digital invoice screen.
     */
    @objc public var  digitalInvoiceInfoViewChevronImageViewTintColor = UIColor.white
    
    /**
     Sets the text color for the warning info view warning labels on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewWarningLabelsTextColor = UIColor.white
    
    /**
     Sets the font for the warning info view top label on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewTopLabelFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    
    /**
     Sets the font for the warning info view middle label on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewMiddleLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    /**
     Sets the font for the warning info view bottom label on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewBottomLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    /**
     Sets the background color for the warning info left button on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewLeftButtonBackgroundColor = UIColor.white
    
    /**
     Sets the border color for the warning info left button on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewLeftButtonBorderColor = UIColor.white
    
    /**
     Sets the title color for the warning info left button on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewLeftkButtonTitleColor = Colors.Gini.blue
    
    /**
     Sets the background color for the warning info right button on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewRightButtonBackgroundColor = UIColor.clear
    
    /**
     Sets the border color for the warning info right button on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewRightButtonBorderColor = UIColor.white
    
    /**
     Sets the title color for the warning info right button on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewRightButtonTitleColor = UIColor.white
    
    /**
     Sets the font for the warning info buttons on the digital invoice screen.
     */
    @objc public var digitalInvoiceInfoViewButtonsFont = UIFont.systemFont(ofSize: 16)
    
    /**
     Shows the return reasons dialog.
     */
    @objc public var enableReturnReasons: Bool = true

    /**
     * Set an adapter implementation to show a custom loading indicator on the document analysis screen.
     */
    public var analysisScreenLoadingIndicator: AnalysisScreenLoadingIndicatorAdapter?
    
    // MARK: - TODO DELETE
    /**
     Sets the font used in the Return Assistant screens by default.
     */
    @objc public lazy var customFont = GiniCaptureFont(regular: UIFont.systemFont(ofSize: 14,
                                                                                                 weight: .regular),
                                                                      bold: UIFont.systemFont(ofSize: 14,
                                                                                              weight: .bold),
                                                                      light: UIFont.systemFont(ofSize: 14,
                                                                                               weight: .light),
                                                                      thin: UIFont.systemFont(ofSize: 14,
                                                                                              weight: .thin),
                                                                      isEnabled: false)

    /**
     Indicates corner radius for primary buttons within the screens
     */
    
    @objc public var primaryButtonCornerRadius: CGFloat = 14
    
    /**
     Indicates border width for primary buttons within the screens
     */
    
    @objc public var primaryButtonBorderWidth: CGFloat = 1
    
    /**
     Indicates shadow corner radius for primary buttons within the screens
     */
    
    @objc public var primaryButtonShadowRadius: CGFloat = 14
    
    /**
     Indicates shadow color for primary buttons within the screens
     */
    
    @objc public var primaryButtonShadowColor = GiniColor(light: UIColor.clear, dark: UIColor.clear)
    
    /**
     Indicates border color for primary buttons within the screens
     */
    
    @objc public var primaryButtonBorderColor = GiniColor(light: UIColor.clear, dark: UIColor.clear)
    
    /**
     Indicates background color for primary buttons within the screens
     */
    
    @objc public var primaryButtonBackgroundColor = GiniColor(light: UIColor.GiniBank.accent1, dark: UIColor.GiniBank.accent1)
    
    /**
     Indicates title color for primary buttons within the screens
     */
    
    @objc public var primaryButtonTitleColor = GiniColor(light: UIColor.GiniBank.light1, dark: UIColor.GiniBank.light1)
    
    
    /**
     Indicates corner radius for outline buttons within the screens
     */
    
    @objc public var outlineButtonCornerRadius: CGFloat = 14
    
    /**
     Indicates border width for outline buttons within the screens
     */
    
    @objc public var outlineButtonBorderWidth: CGFloat = 1
    
    /**
     Indicates shadow corner radius for outline buttons within the screens
     */
    
    @objc public var outlineButtonShadowRadius: CGFloat = 14
    
    /**
     Indicates shadow color for outline buttons within the screens
     */
    
    @objc public var outlineButtonShadowColor = GiniColor(light: UIColor.clear, dark: UIColor.clear)
    
    /**
     Indicates background color for outline buttons within the screens
     */
    
    @objc public var outlineButtonBackground = GiniColor(light: UIColor.clear, dark: UIColor.clear)
    
    /**
     Indicates border color for outline buttons within the screens
     */
    
    @objc public var outlineButtonBorderColor = GiniColor(light: UIColor.GiniBank.light6, dark: UIColor.clear)
    
    /**
     Indicates title color for outline buttons within the screens
     */
    
    @objc public var outlineButtonTitleColor = GiniColor(light: UIColor.GiniBank.dark6, dark: UIColor.GiniBank.light1)
    
    /**
     Set an array of additional custom help menu items . Those items will be presented as table view cells on the help menu screen. By selecting the cell the user will be redirected to the page, which represented by viewController provided by customer during the  `HelpMenuViewController.Item` initialization.
    */
    public var customMenuItems: [HelpMenuItem] = []
    
    /**
     Sets if the default error logging implementation is on.
     */
    public var giniErrorLoggerIsOn: Bool = true
    
    /**
     Should be set if the custom error logging is implemented.
     */
    public var customGiniErrorLoggerDelegate : GiniCaptureErrorLoggerDelegate?
    
    /**
     Should be set if the default name "Localizable.strings" are not used.
     */
    public var localizedStringsTableName: String?
    
    /**
     Set dictionary of fonts for available text styles. Used internally.
     */
    var textStyleFonts: [UIFont.TextStyle: UIFont] = [
    .largeTitle: UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont.systemFont(ofSize: 34)),
    .title1: UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont.systemFont(ofSize: 28)),
    .title2: UIFontMetrics(forTextStyle: .title2).scaledFont(for: UIFont.systemFont(ofSize: 22)),
    .title3: UIFontMetrics(forTextStyle: .title3).scaledFont(for: UIFont.systemFont(ofSize: 20)),
    .caption1: UIFontMetrics(forTextStyle: .caption1).scaledFont(for: UIFont.systemFont(ofSize: 12)),
    .caption2: UIFontMetrics(forTextStyle: .caption2).scaledFont(for: UIFont.systemFont(ofSize: 11)),
    .headline: UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: 17)),
    .subheadline: UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: UIFont.systemFont(ofSize: 15)),
    .body: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.systemFont(ofSize: 17)),
    .bodyBold: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.boldSystemFont(ofSize: 17)),
    .callout: UIFontMetrics(forTextStyle: .callout).scaledFont(for: UIFont.systemFont(ofSize: 16)),
    .calloutBold: UIFontMetrics(forTextStyle: .callout).scaledFont(for: UIFont.boldSystemFont(ofSize: 16)),
    .footnote: UIFontMetrics(forTextStyle: .footnote).scaledFont(for: UIFont.systemFont(ofSize: 13)),
    ]
    
    public func captureConfiguration() -> GiniConfiguration {
     let configuration = GiniConfiguration()
        configuration.customDocumentValidations = self.customDocumentValidations
        
        configuration.customFont = self.customFont
        
        configuration.debugModeOn = self.debugModeOn
        
        configuration.logger = self.logger
        
        configuration.multipageEnabled = self.multipageEnabled
        configuration.customNavigationController = self.customNavigationController

        configuration.navigationBarTintColor = self.navigationBarTintColor
        configuration.navigationBarItemTintColor = self.navigationBarItemTintColor
        configuration.navigationBarItemFont = self.navigationBarItemFont
        configuration.navigationBarTitleColor = self.navigationBarTitleColor
        configuration.navigationBarTitleFont = self.navigationBarTitleFont
        
        configuration.documentPickerNavigationBarTintColor = self.documentPickerNavigationBarTintColor

        configuration.noticeInformationBackgroundColor = self.noticeInformationBackgroundColor
        
        configuration.noticeInformationTextColor = self.noticeInformationTextColor
        configuration.noticeErrorBackgroundColor = self.noticeErrorBackgroundColor
        configuration.noticeErrorTextColor = self.noticeErrorTextColor
        
        configuration.openWithEnabled = self.openWithEnabled
        
        configuration.qrCodeScanningEnabled = self.qrCodeScanningEnabled
        
        configuration.statusBarStyle = self.statusBarStyle
        configuration.cameraPreviewCornerGuidesColor = self.cameraPreviewCornerGuidesColor
        configuration.cameraPreviewFrameColor = self.cameraPreviewFrameColor
        configuration.cameraContainerViewBackgroundColor = self.cameraContainerViewBackgroundColor
        configuration.cameraButtonsViewBackgroundColor = self.cameraButtonsViewBackgroundColor
        
        configuration.fileImportSupportedTypes = self.fileImportSupportedTypes
        configuration.fileImportToolTipBackgroundColor = self.fileImportToolTipBackgroundColor
        configuration.fileImportToolTipTextColor = self.fileImportToolTipTextColor
        configuration.fileImportToolTipCloseButtonColor = self.fileImportToolTipCloseButtonColor
        
        configuration.toolTipOpaqueBackgroundStyle = self.toolTipOpaqueBackgroundStyle

        configuration.galleryPickerItemSelectedBackgroundCheckColor = self.galleryPickerItemSelectedBackgroundCheckColor
        configuration.galleryScreenBackgroundColor = self.galleryScreenBackgroundColor
        
        configuration.flashToggleEnabled = self.flashToggleEnabled
        configuration.flashOnByDefault = self.flashOnByDefault
        
        configuration.imagesStackIndicatorLabelTextcolor = self.imagesStackIndicatorLabelTextcolor
        
        configuration.navigationBarCameraTitleCloseButton = self.navigationBarCameraTitleCloseButton
        configuration.navigationBarCameraTitleHelpButton = self.navigationBarCameraTitleHelpButton
        
        configuration.qrCodePopupButtonColor = self.qrCodePopupButtonColor
        configuration.qrCodePopupTextColor = self.qrCodePopupTextColor
        configuration.qrCodePopupBackgroundColor = self.qrCodePopupBackgroundColor
        configuration.bottomNavigationBarEnabled = self.bottomNavigationBarEnabled
        configuration.cameraNavigationBarBottomAdapter = self.cameraNavigationBarBottomAdapter
        configuration.navigationBarOnboardingTitleContinueButton = self.navigationBarOnboardingTitleContinueButton
        
        configuration.onboardingPageIndicatorColor = self.onboardingPageIndicatorColor
        configuration.onboardingCurrentPageIndicatorColor = self.onboardingCurrentPageIndicatorColor
        configuration.onboardingCurrentPageIndicatorAlpha = self.onboardingCurrentPageIndicatorAlpha
        configuration.onboardingShowAtLaunch = self.onboardingShowAtLaunch
        configuration.onboardingShowAtFirstLaunch = self.onboardingShowAtFirstLaunch
        configuration.onboardingTextColor = self.onboardingTextColor
        configuration.onboardingScreenBackgroundColor = self.onboardingScreenBackgroundColor
        configuration.onboardingNavigationBarBottomAdapter = self.onboardingNavigationBarBottomAdapter
        
        configuration.navigationBarReviewTitleBackButton = self.navigationBarReviewTitleBackButton
        configuration.navigationBarReviewTitleCloseButton = self.navigationBarReviewTitleCloseButton
        configuration.navigationBarReviewTitleContinueButton = self.navigationBarReviewTitleContinueButton
        
        configuration.reviewBottomViewBackgroundColor = self.reviewBottomViewBackgroundColor
        configuration.reviewTextBottomFont = self.reviewTextBottomFont
        configuration.reviewTextBottomColor = self.reviewTextBottomColor
        
        configuration.indicatorCircleColor = self.indicatorCircleColor
        
        configuration.multipagePagesContainerAndToolBarColor = self.multipagePagesContainerAndToolBarColor
        configuration.multipageToolbarItemsColor = self.multipageToolbarItemsColor
        configuration.multipagePageIndicatorColor = self.multipagePageIndicatorColor
        configuration.multipagePageSelectedIndicatorColor = self.multipagePageSelectedIndicatorColor
        configuration.multipagePageBackgroundColor = self.multipagePageBackgroundColor
        configuration.multipageDraggableIconColor = self.multipageDraggableIconColor
        configuration.multipageToolTipOpaqueBackgroundStyle = self.multipageToolTipOpaqueBackgroundStyle
        configuration.multipagePageSuccessfullUploadIconBackgroundColor = self.multipagePageSuccessfullUploadIconBackgroundColor
        configuration.multipagePageFailureUploadIconBackgroundColor = self.multipagePageFailureUploadIconBackgroundColor

        configuration.navigationBarAnalysisTitleBackButton = self.navigationBarAnalysisTitleBackButton
        
        configuration.navigationBarHelpMenuTitleBackToCameraButton = self.navigationBarHelpMenuTitleBackToCameraButton
        configuration.navigationBarHelpScreenTitleBackToMenuButton = self.navigationBarHelpScreenTitleBackToMenuButton
        
        configuration.shouldShowSupportedFormatsScreen = self.shouldShowSupportedFormatsScreen
        
        configuration.nonSupportedFormatsIconColor = self.nonSupportedFormatsIconColor
        
        configuration.supportedFormatsIconColor = self.supportedFormatsIconColor
        
        configuration.openWithAppNameForTexts = self.openWithAppNameForTexts
        
        configuration.stepIndicatorColor = self.stepIndicatorColor
        
        configuration.noResultsBottomButtonColor = self.noResultsBottomButtonColor
        configuration.noResultsBottomButtonTextColor = self.noResultsBottomButtonTextColor
        configuration.noResultsBottomButtonCornerRadius = self.noResultsBottomButtonCornerRadius
        
        configuration.noResultsWarningContainerIconColor = self.noResultsWarningContainerIconColor
        
        configuration.shouldShowDragAndDropTutorial = self.shouldShowDragAndDropTutorial
        
        configuration.customMenuItems = self.customMenuItems
        
        configuration.giniErrorLoggerIsOn = self.giniErrorLoggerIsOn
        configuration.customGiniErrorLoggerDelegate = self.customGiniErrorLoggerDelegate
        configuration.albumsScreenSelectMorePhotosTextColor = self.albumsScreenSelectMorePhotosTextColor

        configuration.analysisScreenLoadingIndicator = self.analysisScreenLoadingIndicator
        
        // Undocumented--Xamarin only
        configuration.closeButtonResource = self.closeButtonResource
        configuration.helpButtonResource = self.helpButtonResource
        configuration.backToCameraButtonResource = self.helpButtonResource
        configuration.backToMenuButtonResource = self.backToMenuButtonResource
        configuration.nextButtonResource = self.nextButtonResource
        configuration.cancelButtonResource = self.cancelButtonResource
        configuration.localizedStringsTableName = self.localizedStringsTableName
        
        for textStyle in UIFont.TextStyle.allCases {
            if let newFont = textStyleFonts[textStyle]{
                configuration.updateFont(newFont, for: textStyle)
            }
        }

        configuration.primaryButtonCornerRadius = self.primaryButtonCornerRadius
        configuration.primaryButtonBorderWidth = self.primaryButtonBorderWidth
        configuration.primaryButtonBorderColor = self.primaryButtonBorderColor
        configuration.primaryButtonShadowColor = self.primaryButtonShadowColor
        configuration.primaryButtonShadowRadius = self.primaryButtonShadowRadius
        configuration.primaryButtonBackgroundColor = self.primaryButtonBackgroundColor
        configuration.primaryButtonTitleColor = self.primaryButtonTitleColor
        
        configuration.outlineButtonCornerRadius = self.outlineButtonCornerRadius
        configuration.outlineButtonBorderColor = self.outlineButtonBorderColor
        configuration.outlineButtonBorderWidth = self.outlineButtonBorderWidth
        configuration.outlineButtonShadowColor = self.outlineButtonShadowColor
        configuration.outlineButtonShadowRadius = self.outlineButtonShadowRadius
        configuration.outlineButtonBackground = self.outlineButtonBackground
        configuration.outlineButtonTitleColor = self.outlineButtonTitleColor
        GiniCapture.setConfiguration(configuration)
        
        // Set onboarding pages after setting the GiniCapture's configuration
        // because the onboarding page initialisers need the configuration
        configuration.onboardingPages = self.onboardingPages
        
        return configuration
    }
    
    public func returnAssistantConfiguration() -> ReturnAssistantConfiguration {
     let configuration = ReturnAssistantConfiguration()
        
        configuration.helpReturnAssistantScreenBackgroundColor = self.helpReturnAssistantScreenBackgroundColor
        configuration.helpReturnAssistantScreenSectionTitleColor = self.helpReturnAssistantScreenSectionTitleColor
        configuration.helpReturnAssistantScreenPageTitleFont = self.helpReturnAssistantScreenPageTitleFont
        configuration.helpReturnAssistantScreenSectionTitleFont = self.helpReturnAssistantScreenSectionTitleFont
        configuration.helpReturnAssistantScreenInstructionColor = self.helpReturnAssistantScreenInstructionColor
        configuration.helpReturnAssistantScreenInstructionFont = self.helpReturnAssistantScreenInstructionFont
        configuration.helpReturnAssistantScreenBackButtonColor = self.helpReturnAssistantScreenBackButtonColor
        configuration.helpReturnAssistantScreenBackButtonTitleColor = self.helpReturnAssistantScreenBackButtonTitleColor
        configuration.helpReturnAssistantScreenBackButtonTitleFont = self.helpReturnAssistantScreenBackButtonTitleFont

        configuration.lineItemTintColor = self.lineItemTintColor
        configuration.lineItemCountLabelColor = self.lineItemCountLabelColor
        configuration.lineItemCountLabelFont = self.lineItemCountLabelFont
        configuration.lineItemBorderColor = self.lineItemBorderColor
        
        configuration.digitalInvoiceLineItemNameFont = self.digitalInvoiceLineItemNameFont
        configuration.digitalInvoiceLineItemEditButtonTitleFont = self.digitalInvoiceLineItemEditButtonTitleFont
        configuration.digitalInvoiceLineItemEditButtonTintColor = self.digitalInvoiceLineItemEditButtonTintColor
        configuration.digitalInvoiceLineItemToggleSwitchTintColor = self.digitalInvoiceLineItemToggleSwitchTintColor
        configuration.digitalInvoiceLineItemDeleteButtonTintColor = self.digitalInvoiceLineItemDeleteButtonTintColor
        configuration.digitalInvoiceLineItemQuantityFont = self.digitalInvoiceLineItemQuantityFont
        configuration.digitalInvoiceLineItemQuantityColor = self.digitalInvoiceLineItemQuantityColor
        configuration.digitalInvoiceLineItemNameColor = self.digitalInvoiceLineItemNameColor
        configuration.digitalInvoiceLineItemPriceColor = self.digitalInvoiceLineItemPriceColor
        configuration.digitalInvoiceLineItemPriceMainUnitFont = self.digitalInvoiceLineItemPriceMainUnitFont
        configuration.digitalInvoiceLineItemPriceFractionalUnitFont = self.digitalInvoiceLineItemPriceFractionalUnitFont
        
        configuration.digitalInvoiceSecondaryMessageTextFont = self.digitalInvoiceSecondaryMessageTextFont
        configuration.digitalInvoiceSecondaryMessageTextColor = self.digitalInvoiceSecondaryMessageTextColor
        configuration.digitalInvoiceBackgroundColor = self.digitalInvoiceBackgroundColor
        configuration.digitalInvoiceLineItemsBackgroundColor = self.digitalInvoiceLineItemsBackgroundColor
        configuration.digitalInvoiceLineItemsDisabledColor = self.digitalInvoiceLineItemsDisabledColor
        configuration.digitalInvoiceFooterAddArticleButtonTintColor = self.digitalInvoiceFooterAddArticleButtonTintColor
        configuration.digitalInvoiceFooterAddArticleButtonTitleFont = self.digitalInvoiceFooterAddArticleButtonTitleFont
        configuration.digitalInvoiceFooterMessageTextFont = self.digitalInvoiceFooterMessageTextFont
        configuration.digitalInvoiceFooterMessageTextColor = self.digitalInvoiceFooterMessageTextColor
        
        configuration.digitalInvoiceItemsSectionHeaderTextFont = self.digitalInvoiceItemsSectionHeaderTextFont
        configuration.digitalInvoiceItemsSectionHeaderTextColor = self.digitalInvoiceItemsSectionHeaderTextColor
        
        configuration.payButtonBackgroundColor = self.payButtonBackgroundColor
        configuration.payButtonTitleTextColor = self.payButtonTitleTextColor
        configuration.payButtonTitleFont = self.payButtonTitleFont
        
        configuration.skipButtonBackgroundColor = self.skipButtonBackgroundColor
        configuration.skipButtonTitleTextColor = self.skipButtonTitleTextColor
        configuration.skipButtonBorderColor = self.skipButtonBorderColor
        configuration.skipButtonTitleFont = self.skipButtonTitleFont
        
        configuration.digitalInvoiceInfoViewBackgroundColor = self.digitalInvoiceInfoViewBackgroundColor
        configuration.digitalInvoiceInfoViewChevronImageViewTintColor = self.digitalInvoiceInfoViewChevronImageViewTintColor
        configuration.digitalInvoiceInfoViewWarningLabelsTextColor = self.digitalInvoiceInfoViewWarningLabelsTextColor
        configuration.digitalInvoiceInfoViewTopLabelFont = self.digitalInvoiceInfoViewTopLabelFont
        configuration.digitalInvoiceInfoViewMiddleLabelFont = self.digitalInvoiceInfoViewMiddleLabelFont
        configuration.digitalInvoiceInfoViewBottomLabelFont = self.digitalInvoiceInfoViewBottomLabelFont
        configuration.digitalInvoiceInfoViewLeftButtonBackgroundColor = self.digitalInvoiceInfoViewLeftButtonBackgroundColor
        configuration.digitalInvoiceInfoViewLeftButtonBorderColor = self.digitalInvoiceInfoViewLeftButtonBorderColor
        configuration.digitalInvoiceInfoViewLeftkButtonTitleColor = self.digitalInvoiceInfoViewLeftkButtonTitleColor
        configuration.digitalInvoiceInfoViewRightButtonBackgroundColor = self.digitalInvoiceInfoViewRightButtonBackgroundColor
        configuration.digitalInvoiceInfoViewRightButtonBorderColor = self.digitalInvoiceInfoViewRightButtonBorderColor
        configuration.digitalInvoiceInfoViewRightButtonTitleColor = self.digitalInvoiceInfoViewRightButtonTitleColor
        configuration.digitalInvoiceInfoViewButtonsFont = self.digitalInvoiceInfoViewButtonsFont
        
        configuration.digitalInvoiceAddonLabelFont = self.digitalInvoiceAddonLabelFont
        configuration.digitalInvoiceTotalCaptionLabelFont = self.digitalInvoiceTotalCaptionLabelFont
        configuration.digitalInvoiceTotalCaptionLabelTextColor = self.digitalInvoiceTotalCaptionLabelTextColor
        configuration.digitalInvoiceTotalExplanationLabelFont = self.digitalInvoiceTotalExplanationLabelFont
        configuration.digitalInvoiceTotalExplanationLabelTextColor = self.digitalInvoiceTotalExplanationLabelTextColor
        configuration.digitalInvoiceAddonPriceMainUnitFont = self.digitalInvoiceAddonPriceMainUnitFont
        configuration.digitalInvoiceAddonPriceFractionalUnitFont = self.digitalInvoiceAddonPriceFractionalUnitFont
        configuration.digitalInvoiceAddonPriceColor = self.digitalInvoiceAddonPriceColor
        configuration.digitalInvoiceAddonLabelColor = self.digitalInvoiceAddonLabelColor
        configuration.digitalInvoiceTotalPriceColor = self.digitalInvoiceTotalPriceColor

        configuration.digitalInvoiceTotalPriceMainUnitFont = self.digitalInvoiceTotalPriceMainUnitFont
        configuration.digitalInvoiceTotalPriceFractionalUnitFont = self.digitalInvoiceTotalPriceFractionalUnitFont
        
        configuration.lineItemDetailsDescriptionLabelFont = self.lineItemDetailsDescriptionLabelFont
        configuration.lineItemDetailsDescriptionLabelColor = self.lineItemDetailsDescriptionLabelColor
        configuration.lineItemDetailsBackgroundColor = self.lineItemDetailsBackgroundColor
        configuration.lineItemDetailsContentLabelFont = self.lineItemDetailsContentLabelFont
        configuration.lineItemDetailsContentLabelColor = self.lineItemDetailsContentLabelColor
        configuration.lineItemDetailsContentHighlightedColor = self.lineItemDetailsContentHighlightedColor
        configuration.lineItemDetailsTotalPriceMainUnitFont = self.lineItemDetailsTotalPriceMainUnitFont
        configuration.lineItemDetailsTotalPriceFractionalUnitFont = self.lineItemDetailsTotalPriceFractionalUnitFont
        
        configuration.digitalInvoiceOnboardingBackgroundColor = self.digitalInvoiceOnboardingBackgroundColor
        configuration.digitalInvoiceOnboardingTextColor = self.digitalInvoiceOnboardingTextColor
        configuration.digitalInvoiceOnboardingFirstLabelTextFont = self.digitalInvoiceOnboardingFirstLabelTextFont
        configuration.digitalInvoiceOnboardingSecondLabelTextFont = self.digitalInvoiceOnboardingSecondLabelTextFont
        configuration.digitalInvoiceOnboardingDoneButtonBackgroundColor = self.digitalInvoiceOnboardingDoneButtonBackgroundColor
        configuration.digitalInvoiceOnboardingDoneButtonTextFont = self.digitalInvoiceOnboardingDoneButtonTextFont
        configuration.digitalInvoiceOnboardingHideButtonTextFont = self.digitalInvoiceOnboardingHideButtonTextFont
        configuration.digitalInvoiceOnboardingDoneButtonTextColor = self.digitalInvoiceOnboardingDoneButtonTextColor
        configuration.digitalInvoiceOnboardingHideButtonTextColor = self.digitalInvoiceOnboardingHideButtonTextColor
        configuration.enableReturnReasons = self.enableReturnReasons
        configuration.customFont = self.customFont
        configuration.textStyleFonts = self.textStyleFonts
        
        // TODO! Add for Xamarin colors
        
     return configuration
    }
    
    /**
     Sets the configuration flags back. Used only in the example app. See `SettingsViewController` for the details.
     */
    public func updateConfiguration(withCaptureConfiguration configuration: GiniConfiguration) {
        
        let giniBankConfiguration = GiniBankConfiguration.shared
        giniBankConfiguration.customFont = configuration.customFont
        
        giniBankConfiguration.debugModeOn = configuration.debugModeOn
                
        giniBankConfiguration.multipageEnabled = configuration.multipageEnabled
        
        giniBankConfiguration.openWithEnabled = configuration.openWithEnabled
        
        giniBankConfiguration.qrCodeScanningEnabled = configuration.qrCodeScanningEnabled
        
        giniBankConfiguration.fileImportSupportedTypes = configuration.fileImportSupportedTypes
        
        giniBankConfiguration.flashToggleEnabled = configuration.flashToggleEnabled
        giniBankConfiguration.flashOnByDefault = configuration.flashOnByDefault
        
        giniBankConfiguration.onboardingShowAtLaunch = configuration.onboardingShowAtLaunch
        giniBankConfiguration.onboardingShowAtFirstLaunch = configuration.onboardingShowAtFirstLaunch
        giniBankConfiguration.shouldShowSupportedFormatsScreen = configuration.shouldShowSupportedFormatsScreen
                                
        giniBankConfiguration.shouldShowDragAndDropTutorial = configuration.shouldShowDragAndDropTutorial
        giniBankConfiguration.bottomNavigationBarEnabled = configuration.bottomNavigationBarEnabled
    }
    
    /**
     Allows setting a custom font for specific text styles. The change will affect all screens where a specific text style was used.
     
     - parameter font: Font that is going to be assosiated with specific text style. You can use scaled font or scale your font with our util method `UIFont.scaledFont(_ font: UIFont, textStyle: UIFont.TextStyle)`
     - parameter textStyle: Constants that describe the preferred styles for fonts. Please, find additional information [here](https://developer.apple.com/documentation/uikit/uifont/textstyle)
    */
    public func updateFont(_ font: UIFont, for textStyle: UIFont.TextStyle) {
        textStyleFonts[textStyle] = font
    }
}
