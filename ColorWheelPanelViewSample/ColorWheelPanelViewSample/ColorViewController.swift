//
//  ColorViewController.swift
//  ColorWheelPanelViewSample
//
//  Created by Yuichi Yoshida on 2022/04/20.
//

import Cocoa
import ColorWheelPanelView

class ColorViewController: NSViewController, ColorWheelPanelViewDelegate {
    
    @IBOutlet var leftView: NSView?
    @IBOutlet var hueSlider: NSSlider?
    @IBOutlet var saturationSlider: NSSlider?
    @IBOutlet var brightnessSlider: NSSlider?
    @IBOutlet var continuousCheckBox: NSButton?
    
    var colorWheelPanelView: ColorWheelPanelView?
    
    @IBAction func checkBoxDidChanged(sender: NSButton) {
        colorWheelPanelView?.isContinuous = (sender.state == .on)
    }
    
    func didChange(hue: Float, saturation: Float, brightness: Float) {
        hueSlider?.floatValue = hue
        saturationSlider?.floatValue = saturation
        brightnessSlider?.floatValue = 1.0 - brightness
    }
    
    @IBAction func brightnessSlider(sender: NSSlider) {
        if let colorWheelPanelView = colorWheelPanelView {
            colorWheelPanelView.brightness = 1 - CGFloat(sender.floatValue)
        }
    }
    
    @IBAction func saturationSlider(sender: NSSlider) {
        if let colorWheelPanelView = colorWheelPanelView {
            colorWheelPanelView.saturation = CGFloat(sender.floatValue)
        }
    }
    
    @IBAction func hueSlider(sender: NSSlider) {
        if let colorWheelPanelView = colorWheelPanelView {
            colorWheelPanelView.hue = CGFloat(sender.floatValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = ColorWheelPanelView()
        
        colorWheelPanelView = v
        
        v.frame = NSRect(x: 0, y: 0, width: 300, height: 200)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.delegate = self
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

