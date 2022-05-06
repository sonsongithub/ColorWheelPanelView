//
//  BrightnessSliderCell.swift
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

#if os(macOS)

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

#endif
