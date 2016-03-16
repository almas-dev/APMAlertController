//
// Created by Xander on 04.03.16.
//

import Foundation

public enum APMAlertActionStyle {
    case Default
    case Cancel
    case Destructive
}

public class APMAlertAction : NSObject {
    let title: String
    let style: APMAlertActionStyle
    let handler: ((APMAlertAction!) -> Void)!

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    public init(title: String, style: APMAlertActionStyle, handler: ((APMAlertAction!) -> Void)!) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
