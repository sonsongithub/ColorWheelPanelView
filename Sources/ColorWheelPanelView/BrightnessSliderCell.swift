//
//  File.swift
//  
//
//  Created by Yuichi Yoshida on 2022/04/21.
//

import Cocoa

internal class BrightnessSliderCell: NSSliderCell {
    
    override func drawKnob(_ knobRect: NSRect) {
        let x = knobRect.origin.x
        let y = knobRect.origin.y
        let width = knobRect.size.width
        let height = knobRect.size.height

        let path = NSBezierPath(roundedRect: NSRect(x: x + 7, y: y+2, width: width - 14, height: height - 8), xRadius: 5, yRadius: 5)
        NSColor.white.setFill()
        path.fill()
        
        path.lineWidth = 1
        NSColor.lightGray.setStroke()
        path.stroke()
    }
    
    override func drawBar(inside rect: NSRect, flipped: Bool) {
        // nothing to be drawn
    }
}
