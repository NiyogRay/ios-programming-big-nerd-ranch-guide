import Foundation
import CoreGraphics

struct Circle {
    
    var point1 = CGPoint.zero
    var point2 = CGPoint.zero
    
    var boundingRect: CGRect {
        let width = abs(point1.x - point2.x)
        let height = abs(point1.y - point2.y)
        let x = min(point1.x, point2.x)
        let y = min(point1.y, point2.y)
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        return rect
    }
}

