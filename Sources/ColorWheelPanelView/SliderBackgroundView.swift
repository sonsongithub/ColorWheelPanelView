//
//  SliderBackgroundView.swift
//  ColorWheelPanelView
//
//  Created by Yuichi Yoshida on 2022/04/20.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Cocoa

internal class SliderBackgroundView: NSView {
    
    var hue: Double = 0 {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    var saturation: Double = 0 {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
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
