import UIKit

class DrawView: UIView {
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    
    var currentCircle = Circle()
    var finishedCircles = [Circle]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    func stroke(circle: Circle) {
        let path = UIBezierPath(ovalIn: circle.boundingRect)
        path.lineWidth = lineThickness
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line: line)
        }
        // Draw current lines
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            stroke(line: line)
        }
        // Draw finished circles
        finishedLineColor.setStroke()
        for circle in finishedCircles {
            stroke(circle: circle)
        }
        // Draw current circle
        currentLineColor.setStroke()
        stroke(circle: currentCircle)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        if touches.count == 2 {
            let touchesArray = Array(touches)
            let point1 = touchesArray.first!.location(in: self)
            let point2 = touchesArray.last!.location(in: self)
            currentCircle.point1 = point1
            currentCircle.point2 = point2
        }
        else {
            for touch in touches {
                let location = touch.location(in: self)
                
                let newLine = Line(begin: location, end: location)
                
                let key = NSValue(nonretainedObject: touch)
                currentLines[key] = newLine
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        if touches.count == 2 {
            let touchesArray = Array(touches)
            let point1 = touchesArray.first!.location(in: self)
            let point2 = touchesArray.last!.location(in: self)
            currentCircle.point1 = point1
            currentCircle.point2 = point2
        }
        else {
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                currentLines[key]?.end = touch.location(in: self)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        if touches.count == 2 {
            let touchesArray = Array(touches)
            let point1 = touchesArray.first!.location(in: self)
            let point2 = touchesArray.last!.location(in: self)
            currentCircle.point1 = point1
            currentCircle.point2 = point2
            finishedCircles.append(currentCircle)
            currentCircle = Circle()
        }
        else {
            for touch in touches {
                let key = NSValue(nonretainedObject: touch)
                if var line = currentLines[key] {
                    line.end = touch.location(in: self)
                    
                    finishedLines.append(line)
                    currentLines.removeValue(forKey: key)
                }
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        currentCircle = Circle()
        
        setNeedsDisplay()
    }
}

