//
//  AnalyticsManager.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import UIKit

public class AnalyticsManager {
    private static var amplitudeService: AmplitudeService? {
        didSet {
            handleAnalyticsSDKsInit()
        }
    }
    private static var userProperties: [AnalyticsUserProperty: AnalyticsPropertyValue] = [:]
    private static var amplitudeSuperPropertiesToTrack: [String: String] = [:]
    private static var amplitudeUserPropertiesToTrack: [String: String] = [:]
    private static var superProperties: [AnalyticsSuperProperty: AnalyticsPropertyValue] = [:]
    private static var sessionId: Int64?

    private static var eventsQueue: [QueuedAnalyticsEvent] = []
    private static let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private static var eventId: Int64 = 0

    public static func initializeAnalytics(with configuration: AnalyticsConfiguration) {
        guard configuration.userJourneyAnalyticsEnabled,
              GiniTrackingPermissionManager.shared.trackingAuthorized() else { return }
        // Generate a new session identifier
        sessionId = Date.berlinTimestamp()
        superProperties[.giniClientID] = configuration.clientID
        initializeAmplitude(with: configuration.amplitudeApiKey)

        sessionId = Date.berlinTimestamp()
    }

    public static func cleanManager() {
        userProperties = [:]
        superProperties = [:]
        eventsQueue = []
        sessionId = nil
    }

    // MARK: Initialization

    private static func initializeAmplitude(with apiKey: String?) {
        amplitudeService = AmplitudeService(apiKey: apiKey)
    }

    private static func handleAnalyticsSDKsInit() {
        guard amplitudeService != nil else { return }
        registerSuperProperties(superProperties)
        trackUserProperties(userProperties)
        trackAccessibilityUserPropertiesAtInitialization()
        processEventsQueue()
    }

    // MARK: - Event counter
    private static func incrementEventId() -> Int64 {
        eventId += 1
        return eventId
    }

    // MARK: - Track screen shown
    public static func trackScreenShown(screenName: AnalyticsScreen,
                                        properties: [AnalyticsProperty] = []) {
        track(event: AnalyticsEvent.screenShown,
              screenName: screenName,
              properties: properties)
    }

    static func trackScreenShown(screenNameString: String,
                                 properties: [AnalyticsProperty] = []) {
        track(event: AnalyticsEvent.screenShown,
              screenNameString: screenNameString,
              properties: properties)
    }

    // MARK: - Track event on screen
    public static func track(event: AnalyticsEvent,
                             screenName: AnalyticsScreen? = nil,
                             properties: [AnalyticsProperty] = []) {
        track(event: event,
              screenNameString: screenName?.rawValue,
              properties: properties)

    }

    static func track(event: AnalyticsEvent,
                      screenNameString: String? = nil,
                      properties: [AnalyticsProperty] = []) {
        let queuedEvent = QueuedAnalyticsEvent(event: event,
                                               screenNameString: screenNameString,
                                               properties: properties)
        eventsQueue.append(queuedEvent)

        // Process the event queue if AmplitudeService is initialized
        if amplitudeService != nil {
            processEventsQueue()
        }
    }
    /// Processes the events queue by sending each queued event to Mixpanel and Amplitude
    private static func processEventsQueue() {
        var baseEvents: [BaseEvent] = []

        while !eventsQueue.isEmpty {
            let queuedEvent = eventsQueue.removeFirst()
            if let baseEvent = convertToBaseEvent(event: queuedEvent) {
                baseEvents.append(baseEvent)
            }
        }

        amplitudeService?.trackEvents(baseEvents)
    }

    /// Converts a QueuedAnalyticsEvent to a BaseEvent
    private static func convertToBaseEvent(event: QueuedAnalyticsEvent) -> BaseEvent? {
        var eventProperties: [String: String] = [:]

        if let screenName = event.screenNameString {
            eventProperties[AnalyticsPropertyKey.screenName.rawValue] = screenName
        }

        for property in event.properties {
            let propertyValue = property.value.analyticsPropertyValue()
            eventProperties[property.key.rawValue] = convertPropertyValueToString(propertyValue)
        }

        let baseEvent = BaseEvent(eventType: event.event.rawValue)

        // Merge event properties with super properties. In case of key collisions, values from eventProperties will be used.
        baseEvent.eventProperties = eventProperties.merging(amplitudeSuperPropertiesToTrack) { (_, new) in new }
        baseEvent.userProperties = amplitudeUserPropertiesToTrack
        let iosSystem = IOSSystem()
        let eventId = incrementEventId()
        let eventOptions = EventOptions(userId: deviceID,
                                        deviceId: iosSystem.identifierForVendor,
                                        time: Date.berlinTimestamp(),
                                        sessionId: sessionId,
                                        platform: iosSystem.platform,
                                        osVersion: iosSystem.osVersion,
                                        osName: iosSystem.osName,
                                        language: iosSystem.systemLanguage,
                                        ip: "$remote",
                                        eventId: eventId,
                                        deviceModel: iosSystem.model,
                                        deviceBrand: iosSystem.manufacturer,
                                        appVersion: GiniCapture.versionString)
        baseEvent.mergeEventOptions(eventOptions: eventOptions)
        return baseEvent
    }

    public static func trackUserProperties(_ properties: [AnalyticsUserProperty: AnalyticsPropertyValue]) {
        handleProperties(properties, propertyStore: &userProperties) {
            amplitudeUserPropertiesToTrack = $0
        }
    }

    public static func registerSuperProperties(_ properties: [AnalyticsSuperProperty: AnalyticsPropertyValue]) {
        handleProperties(properties, propertyStore: &superProperties) {
            amplitudeSuperPropertiesToTrack = $0
        }
    }

    private static func trackAccessibilityUserPropertiesAtInitialization() {
        let accessibilityProperties: [AnalyticsUserProperty: AnalyticsPropertyValue] = [
            .voiceOverEnabled: UIAccessibility.isVoiceOverRunning,
            .guidedAccessEnabled: UIAccessibility.isGuidedAccessEnabled,
            .boldTextEnabled: UIAccessibility.isBoldTextEnabled,
            .grayscaleEnabled: UIAccessibility.isGrayscaleEnabled,
            .speakSelectionEnabled: UIAccessibility.isSpeakSelectionEnabled,
            .speakScreenEnabled: UIAccessibility.isSpeakScreenEnabled,
            .assistiveTouchEnabled: UIAccessibility.isAssistiveTouchRunning
        ]
        trackUserProperties(accessibilityProperties)
    }

    // MARK: - Helper methods
    private static func boolToString(from original: Bool) -> String {
        return original ? "yes" : "no"
    }

    private static func arrayToString(from original: [String]) -> String {
        return "[\(original.map { "\"\($0)\"" }.joined(separator: ", "))]"
    }

    private static func convertPropertyValueToString(_ value: AnalyticsPropertyValue) -> String {
        switch value {
        case let value as Bool:
            return boolToString(from: value)
        case let value as String:
            return value
        case let value as Int:
            return "\(value)"
        case let value as [String]:
            return arrayToString(from: value)
        default:
            return ""
        }
    }

    private static func handleProperties<T: RawRepresentable>(_ properties: [T: AnalyticsPropertyValue],
                                                              propertyStore: inout [T: AnalyticsPropertyValue],
                                                              propertiesHandler: ([String: String]) -> Void)
    where T.RawValue == String {
        if amplitudeService != nil {
            let propertiesToTrack = mapProperties(properties)
            propertiesHandler(propertiesToTrack)
        } else {
            propertyStore.merge(properties) { (_, new) in new }
        }
    }

    private static func mapProperties<T: RawRepresentable>(_ properties: [T: AnalyticsPropertyValue]) 
    -> [String: String]
    where T.RawValue == String {
        return properties.reduce(into: [String: String]()) { dict, pair in
            dict[pair.key.rawValue] = convertPropertyValueToString(pair.value)
        }
    }
}
