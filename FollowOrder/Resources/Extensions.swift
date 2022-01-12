//
//  Extensions.swift
//  FollowTheOrder
//
//  Created by Valados on 12.12.2021.
//

import Foundation
import UIKit
import SpriteKit

extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }

    public var viewHeight: CGFloat {
        return self.frame.size.height
    }
}
extension Int{
   static func isqrt(_ n: Int) -> Int {
       var r = Int(Double(n).squareRoot()) // Initial approximation
       if r * r < n { r+=1 }
       return r
    }
}

