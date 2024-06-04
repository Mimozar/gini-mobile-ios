//
//  AnalyticsEvent.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import Foundation

public enum AnalyticsEvent: String {
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

    // MARK: Camera permission
    case cameraPermissionShown = "camera_permission_shown"
    case cameraPermissionTapped = "camera_permission_tapped"
    case giveAccessTapped = "give_access_tapped"

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

    // MARK: - Help
    case helpItemTapped = "help_item_tapped"

    // MARK: - Onboarding
    case skipTapped = "skip_tapped"
    case nextStepTapped = "next_step_tapped"
    case getStartedTapped = "get_started_tapped"

    // MARK: - Return assistant
    case dismissed
    case saveTapped = "save_tapped"
    case editTapped = "edit_tapped"
    case itemSwitchTapped = "item_switch_tapped"
    case proceedTapped = "proceed_tapped"
}
