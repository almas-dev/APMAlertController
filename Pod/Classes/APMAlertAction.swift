//
// Created by Xander on 04.03.16.
//

import Foundation

public enum APMAlertActionStyle {
    case `default`
    case cancel
    case destructive
}

public protocol APMAlertActionProtocol {
    var title: String { get }
    var style: APMAlertActionStyle { get }
    var handler: ((APMAlertActionProtocol) -> Void)? { get }
}

public struct APMAlertAction: APMAlertActionProtocol {
    public let title: String
    public let style: APMAlertActionStyle
    public let handler: ((APMAlertActionProtocol) -> Void)?

    public init(title: String, style: APMAlertActionStyle, handler: ((APMAlertActionProtocol) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
