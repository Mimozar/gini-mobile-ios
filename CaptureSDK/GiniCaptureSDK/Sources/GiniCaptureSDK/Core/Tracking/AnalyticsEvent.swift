//
//  AnalyticsEvent.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import Foundation

enum AnalyticsEvent: String {
    case screenShown = "screen_shown"
    case closeTapped = "close_tapped"

    // MARK: - Camera
    case captureTapped = "capture_tapped"
    case importFilesTapped = "import_files_tapped"
    case uploadPhotosTapped = "upload_photos_tapped"
    case uploadDocumentsTapped = "upload_documents_tapped"
    case flashTapped = "flash_tapped"
    case helpTapped = "help_tapped"
    case multiplePagesCapturedTapped = "multiple_pages_captured_tapped"
    case errorDialogShown = "error_dialog_shown"
    case qr_code_scanned = "qr_code_scanned"

    // MARK: - Review
    case processTapped = "process_tapped"
    case deletePagesTapped = "delete_pages_tapped"
    case addPagesTapped = "add_pages_tapped"
    case pageSwiped = "page_swiped"
    case fullScreenPageTapped = "full_screen_page_tapped"

    // MARK: - No Results and Error
    case enterManuallyTapped = "enter_manually_tapped"
    case retakeImagesTapped = "retake_images_tapped"
    case backToCameraTapped = "back_to_camera_tapped"
}
