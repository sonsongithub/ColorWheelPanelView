//
//  File.swift
//  
//
//  Created by Yuichi Yoshida on 2022/04/21.
//

import Cocoa

public protocol GraySliderPanelViewDelegate {
    func didChange(brightness: CGFloat)
}

public class GraySliderPanelView: NSView {
    
    public var delegate: GraySliderPanelViewDelegate?
    
    let margin = CGFloat(8)
    
    private let brightnessSlider: NSSlider = NSSlider(frame: .zero)
    private let sliderBackgroudView = SliderBackgroundView(frame: .zero)
    
    public var brightness: CGFloat = 0 {
        didSet {
            brightnessSlider.floatValue = 1.0 - Float(brightness)
            if let delegate = delegate {
                delegate.didChange(brightness: brightness)
            }
        }
    }
    
    public var isContinuous = false {
        didSet {
            brightnessSlider.isContinuous = isContinuous
        }
    }
    
    @IBAction func didchange(sender: NSSlider) {
        self.brightness = 1 - CGFloat(sender.floatValue)
    }
        
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        brightnessSlider.cell = BrightnessSliderCell()
        
        brightnessSlider.target = self
        brightnessSlider.action = #selector(self.didchange(sender:))
        
        self.addSubview(sliderBackgroudView)
        self.addSubview(brightnessSlider)
        
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        sliderBackgroudView.translatesAutoresizingMaskIntoConstraints = false
        
        self.wantsLayer = true

        self.addConstraints([
            self.centerXAnchor.constraint(equalTo: brightnessSlider.centerXAnchor),
            self.centerXAnchor.constraint(equalTo: sliderBackgroudView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: brightnessSlider.centerYAnchor),
            brightnessSlider.centerXAnchor.constraint(equalTo: sliderBackgroudView.centerXAnchor),
            brightnessSlider.centerYAnchor.constraint(equalTo: sliderBackgroudView.centerYAnchor),
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
