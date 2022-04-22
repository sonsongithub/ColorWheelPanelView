//
//  GrayViewController.swift
//  ColorWheelPanelViewSample
//
//  Created by Yuichi Yoshida on 2022/04/21.
//

import Cocoa
import ColorWheelPanelView

class GrayViewController: NSViewController, GraySliderPanelViewDelegate {
    
    func didChange(brightness: CGFloat) {
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
