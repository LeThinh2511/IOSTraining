//
//  DrawView.swift
//  TouchTracker
//
//  Created by ThinhLe on 4/20/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class DrawView: UIView
{
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    
    func stroke(_ line: Line)
    {
        print(#function)
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        print(#function)
        UIColor.black.setStroke()
        for line in finishedLines
        {
            stroke(line)
        }
        
        UIColor.red.setStroke()
        for (_ , line) in currentLines
        {
            stroke(line)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        for touch in touches
        {
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        for touch in touches
        {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        for touch in touches
        {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key]
            {
                line.end = touch.location(in: self)
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        currentLines.removeAll()
        setNeedsDisplay()
    }
}
