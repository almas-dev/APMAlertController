//
// Created by Xander on 04.03.16.
//

import Foundation

@objc public enum APMAlertActionStyle: Int {
    case `default`
    case cancel
    case destructive
}

@objc public protocol APMAlertActionProtocol {
    var title: String { get }
    var style: APMAlertActionStyle { get }
    var handler: ((APMAlertActionProtocol) -> Void)? { get }
}

@objc open class APMAlertAction: NSObject, APMAlertActionProtocol {
    open let title: String
    open let style: APMAlertActionStyle
    open let handler: ((APMAlertActionProtocol) -> Void)?

    public init(title: String, style: APMAlertActionStyle, handler: ((APMAlertActionProtocol) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
        super.init()
    }
}
