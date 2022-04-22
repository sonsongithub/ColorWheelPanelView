
import Cocoa

public protocol ColorWheelPanelViewDelegate {
    func didChange(hue: Float, saturation: Float, brightness: Float)
}

public class ColorWheelPanelView: NSView, ColorWheelViewDelegate {
    
    public var delegate: ColorWheelPanelViewDelegate?
    
    let margin = CGFloat(8)
    
    func didUpdateColor(hue: CGFloat, saturation: CGFloat) {
        sliderBackgroudView.didUpdateColor(hue: hue, saturation: saturation)
        if let delegate = delegate {
            delegate.didChange(hue: Float(colorWheelView.hue), saturation: Float(colorWheelView.saturation), brightness: Float(colorWheelView.brightness))
        }
    }
    
    public var isContinuous = false {
        didSet {
            brightnessSlider.isContinuous = isContinuous
            colorWheelView.isContinuous = isContinuous
        }
    }
    
    let brightnessSlider: NSSlider = NSSlider(frame: .zero)
    private let colorWheelView = ColorWheelView(frame: .zero)
    private let sliderBackgroudView = SliderBackgroundView(frame: .zero)
    
    public var brightness: CGFloat = 1.0 {
        didSet {
            colorWheelView.brightness = CGFloat(brightness)
            brightnessSlider.floatValue = 1.0 - Float(brightness)
        }
    }
    
    public var hue: CGFloat = 0 {
        didSet {
            sliderBackgroudView.hue = hue
            colorWheelView.hue = hue
        }
    }
    
    public var saturation: CGFloat = 0 {
        didSet {
            sliderBackgroudView.saturation = saturation
            colorWheelView.saturation = saturation
        }
    }
    
    @IBAction func didchange(sender: NSSlider) {
        print(sender.floatValue)
        colorWheelView.brightness = 1.0 - CGFloat(sender.floatValue)
        if let delegate = delegate {
            delegate.didChange(hue: Float(colorWheelView.hue), saturation: Float(colorWheelView.saturation), brightness: Float(colorWheelView.brightness))
        }
    }
        
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        brightnessSlider.cell = BrightnessSliderCell()
        
        brightnessSlider.target = self
        brightnessSlider.action = #selector(self.didchange(sender:))
        
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
            colorWheelView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            brightnessSlider.topAnchor.constraint(equalTo: colorWheelView.bottomAnchor, constant: margin),
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
