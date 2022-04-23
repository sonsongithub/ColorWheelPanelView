//
//  ColorWheelPanelView.swift
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

public protocol ColorWheelPanelViewDelegate {
    func didChangeColor(hue: Double, saturation: Double, brightness: Double)
}

public class ColorWheelPanelView: NSView, ColorWheelViewDelegate {

    public var delegate: ColorWheelPanelViewDelegate?
    
    public var isContinuous = false {
        didSet {
            brightnessSlider.isContinuous = isContinuous
            colorWheelView.isContinuous = isContinuous
        }
    }
    
    private let brightnessSlider: NSSlider = NSSlider(frame: .zero)
    private let colorWheelView = ColorWheelView(frame: .zero)
    private let sliderBackgroudView = SliderBackgroundView(frame: .zero)
    
    public var hue: Double = 0 {
        didSet {
            sliderBackgroudView.hue = hue
            colorWheelView.updateContents(hue: hue, saturation: saturation, brightness: brightness)
        }
    }
    
    public var saturation: Double = 0 {
        didSet {
            sliderBackgroudView.saturation = saturation
            colorWheelView.updateContents(hue: hue, saturation: saturation, brightness: brightness)
        }
    }
    
    public var brightness: Double = 1.0 {
        didSet {
            colorWheelView.updateContents(hue: hue, saturation: saturation, brightness: brightness)
            brightnessSlider.doubleValue = 1.0 - brightness
        }
    }
    
    @IBAction private func didBrightnessSliderChange(sender: NSSlider) {
        brightness = 1.0 - CGFloat(sender.floatValue)
        self.callDelegate()
    }
    
    internal func callDelegate() {
        if let delegate = delegate {
            delegate.didChangeColor(hue: hue, saturation: saturation, brightness: brightness)
        }
    }
    
    public override func layout() {
        super.layout()
        colorWheelView.updateContents(hue: hue, saturation: saturation, brightness: brightness)
        brightnessSlider.floatValue = 1.0 - Float(brightness)
    }
        
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        brightnessSlider.cell = BrightnessSliderCell()
        
        brightnessSlider.target = self
        brightnessSlider.action = #selector(self.didBrightnessSliderChange(sender:))
        
        self.addSubview(sliderBackgroudView)
        self.addSubview(colorWheelView)
        self.addSubview(brightnessSlider)
        
        colorWheelView.translatesAutoresizingMaskIntoConstraints = false
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        sliderBackgroudView.translatesAutoresizingMaskIntoConstraints = false
        
        colorWheelView.delegate = self
        
        self.wantsLayer = true

        self.addConstraints([
            self.centerXAnchor.constraint(equalTo: colorWheelView.centerXAnchor),
            self.centerXAnchor.constraint(equalTo: brightnessSlider.centerXAnchor),
            self.centerXAnchor.constraint(equalTo: sliderBackgroudView.centerXAnchor),
            colorWheelView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            brightnessSlider.topAnchor.constraint(equalTo: colorWheelView.bottomAnchor, constant: 8),
            brightnessSlider.centerXAnchor.constraint(equalTo: sliderBackgroudView.centerXAnchor),
            brightnessSlider.centerYAnchor.constraint(equalTo: sliderBackgroudView.centerYAnchor, constant: 0),
        ])
        
        self.colorWheelView.addConstraints([
            colorWheelView.widthAnchor.constraint(equalToConstant: 167),
            colorWheelView.heightAnchor.constraint(equalToConstant: 167)
        ])
        brightnessSlider.addConstraints([
            brightnessSlider.widthAnchor.constraint(equalToConstant: 228),
            brightnessSlider.heightAnchor.constraint(equalToConstant: 20)
        ])
        sliderBackgroudView.addConstraints([
            sliderBackgroudView.widthAnchor.constraint(equalToConstant: 228 - 8),
            sliderBackgroudView.heightAnchor.constraint(equalToConstant: 14)
        ])
        
//        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
