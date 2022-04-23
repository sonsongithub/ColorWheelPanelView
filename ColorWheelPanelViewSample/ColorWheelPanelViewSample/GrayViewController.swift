//
//  GrayViewController.swift
//  ColorWheelPanelViewSample
//
//  Created by Yuichi Yoshida on 2022/04/21.
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
import ColorWheelPanelView

class GrayViewController: NSViewController, GraySliderPanelViewDelegate {
    
    func didChangeColor(brightness: Double) {
        brightnessSlider?.floatValue = 1 - Float(brightness)
    }

    @IBOutlet var leftView: NSView?
    @IBOutlet var brightnessSlider: NSSlider?
    @IBOutlet var continuousCheckBox: NSButton?
    
    var graySliderPanelView: GraySliderPanelView?
    
    @IBAction func brightnessSlider(sender: NSSlider) {
        if let graySliderPanelView = graySliderPanelView {
            graySliderPanelView.brightness = 1 - CGFloat(sender.floatValue)
        }
    }
    
    @IBAction func checkBoxDidChanged(sender: NSButton) {
        graySliderPanelView?.isContinuous = (sender.state == .on)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = GraySliderPanelView()
        
        v.frame = NSRect(x: 0, y: 0, width: 300, height: 200)
        self.view.addSubview(v)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.delegate = self
        
        self.graySliderPanelView = v
        v.isContinuous = true
    
        if let leftView = leftView {
            leftView.addSubview(v)
            leftView.addConstraints([
                leftView.centerXAnchor.constraint(equalTo: v.centerXAnchor),
                leftView.centerYAnchor.constraint(equalTo: v.centerYAnchor)
            ])
            v.addConstraints([
                v.widthAnchor.constraint(equalToConstant: 300),
                v.heightAnchor.constraint(equalToConstant: 220),
            ])
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
