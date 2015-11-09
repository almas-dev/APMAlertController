//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit

public enum APMAlertActionStyle {
    case Default
    case Cancel
    case Destructive
}

class APMAlertAction : NSObject {
    let title: String
    let style: APMAlertActionStyle
    let handler: ((APMAlertAction!) -> Void)!

    required init(title: String, style: APMAlertActionStyle, handler: ((APMAlertAction!) -> Void)!) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}