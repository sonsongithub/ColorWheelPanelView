//
//  File.swift
//  
//
//  Created by Yuichi Yoshida on 2022/04/21.
//

import Cocoa

internal class SliderBackgroundView: NSView {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    
    func didUpdateColor(hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.setNeedsDisplay(self.bounds)
    }
    override func draw(_ dirtyRect: NSRect) {
        let colorStart = NSColor(calibratedHue: hue, saturation: saturation, brightness: 1, alpha: 1)
        let colorEndA = NSColor(calibratedHue: hue, saturation: saturation, brightness: 0, alpha: 1)

        let gradientA = NSGradient(starting: colorStart, ending: colorEndA)
        
        
        let rect2 = self.bounds
        let rounded = NSBezierPath(roundedRect: rect2, xRadius: 4, yRadius: 4)

        rounded.setClip()

        gradientA?.draw(in: rect2, angle: 0)
        
        NSColor.gray.setStroke()
        let path = NSBezierPath(roundedRect: rect2, xRadius: 4, yRadius: 4)
        path.lineWidth = 2
        path.stroke()
    }
}
