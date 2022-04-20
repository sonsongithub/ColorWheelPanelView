
import AppKit
import Cocoa

// Typealias for RGB color values
typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

// Typealias for HSV color values
typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

func hsv2rgb(_ hsv: HSV) -> RGB {
    // Converts HSV to a RGB color
    var rgb: RGB = (red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
    
    let i = Int(hsv.hue * 6)
    let f = hsv.hue * 6 - CGFloat(i)
    let p = hsv.brightness * (1 - hsv.saturation)
    let q = hsv.brightness * (1 - f * hsv.saturation)
    let t = hsv.brightness * (1 - (1 - f) * hsv.saturation)
    switch (i % 6) {
        case 0: r = hsv.brightness; g = t; b = p; break;
        
        case 1: r = q; g = hsv.brightness; b = p; break;
        
        case 2: r = p; g = hsv.brightness; b = t; break;
        
        case 3: r = p; g = q; b = hsv.brightness; break;
        
        case 4: r = t; g = p; b = hsv.brightness; break;
        
        case 5: r = hsv.brightness; g = p; b = q; break;
        
        default: r = hsv.brightness; g = t; b = p;
    }
    
    rgb.red = r
    rgb.green = g
    rgb.blue = b
    rgb.alpha = hsv.alpha
    return rgb
}

func rgb2hsv(_ rgb: RGB) -> HSV {
    // Converts RGB to a HSV color
    var hsb: HSV = (hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.0)
    
    let rd: CGFloat = rgb.red
    let gd: CGFloat = rgb.green
    let bd: CGFloat = rgb.blue

    let maxV: CGFloat = max(rd, max(gd, bd))
    let minV: CGFloat = min(rd, min(gd, bd))
    var h: CGFloat = 0
    var s: CGFloat = 0
    let b: CGFloat = maxV
    
    let d: CGFloat = maxV - minV
    
    s = maxV == 0 ? 0 : d / minV;
    
    if (maxV == minV) {
        h = 0
    } else {
        if (maxV == rd) {
            h = (gd - bd) / d + (gd < bd ? 6 : 0)
        } else if (maxV == gd) {
            h = (bd - rd) / d + 2
        } else if (maxV == bd) {
            h = (rd - gd) / d + 4
        }
        
        h /= 6;
    }
    
    hsb.hue = h
    hsb.saturation = s
    hsb.brightness = b
    hsb.alpha = rgb.alpha
    return hsb
}

extension NSBezierPath {
    
    /// A `CGPath` object representing the current `NSBezierPath`.
    var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)

        if elementCount > 0 {
            var didClosePath = true

            for index in 0..<elementCount {
                let pathType = element(at: index, associatedPoints: points)

                switch pathType {
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                    didClosePath = false
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                @unknown default:
                    break
                }
            }

            if !didClosePath { path.closeSubpath() }
        }

        points.deallocate()
        return path
    }
}

private protocol ColorWheelViewDelegate {
    func didUpdateColor(hue: CGFloat, saturation: CGFloat)
}

private class ColorWheelView: NSView {
    
    var delegate: ColorWheelViewDelegate?
    
    let wheelLayer = CALayer()
    let borderLayer = CAShapeLayer()
    
    let scope = NSImageView(image: NSImage(systemSymbolName: "scope", accessibilityDescription: nil)!)
    
    var brightness = CGFloat(1) {
        didSet {
            if wheelLayer.frame.size.width > 0 {
                wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
            }
        }
    }
    
    var hue = CGFloat(0) {
        didSet {
            print("hue = \(hue)")
            print("saturation = \(saturation)")
            let radius = wheelLayer.frame.width / 2
            let x = cos(hue * Double.pi * 2) * saturation * radius + radius
            let y = sin(hue * Double.pi * 2) * saturation * radius + radius
            
            print(x)
            print(y)
            
            var rect = self.scope.frame
            rect.origin = CGPoint(x: x - rect.size.width/2, y: y - rect.size.height/2)
            self.scope.frame = rect
        }
    }
    
    var saturation = CGFloat(0) {
        didSet {
            print("hue = \(hue)")
            print("saturation = \(saturation)")
            let radius = wheelLayer.frame.width / 2
            
            print("hue - \(hue)")
            
            let x = cos(hue * Double.pi * 2) * saturation * radius + radius
            let y = sin(hue * Double.pi * 2) * saturation * radius + radius
            
            print(x)
            print(y)
            var rect = self.scope.frame
            rect.origin = CGPoint(x: x - rect.size.width/2, y: y - rect.size.height/2)
            self.scope.frame = rect
        }
    }
    
    let scale: CGFloat = NSScreen.main!.backingScaleFactor
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.allowedTouchTypes = .direct
        self.layer?.backgroundColor = NSColor.green.cgColor
        
        self.layer?.addSublayer(wheelLayer)
        self.layer?.addSublayer(borderLayer)
        self.addSubview(scope)
        
    }
    
    override var wantsDefaultClipping: Bool {
        return false
    }
    
    override func layout() {
        super.layout()
        print("layout")
        borderLayer.path = NSBezierPath(ovalIn: CGRect(x: 1, y: 1, width: self.frame.width-2, height: self.frame.height-2)).cgPath
        borderLayer.fillColor = CGColor.clear
        borderLayer.strokeColor = CGColor.init(gray: 0.4, alpha: 1.0)
        borderLayer.lineWidth = 1
        
        wheelLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        if wheelLayer.frame.size.width > 0 {
            wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
        }
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    func getIndicatorCoordinate(_ coord: CGPoint) -> (point: CGPoint, isCenter: Bool) {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel
        
        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius: CGFloat = dimension/2
        let wheelLayerCenter: CGPoint = CGPoint(x: wheelLayer.frame.origin.x + radius, y: wheelLayer.frame.origin.y + radius)

        let dx: CGFloat = coord.x - wheelLayerCenter.x
        let dy: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(dx*dx + dy*dy)
        var outputCoord: CGPoint = coord
        
        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if (distance > radius) {
            let theta: CGFloat = atan2(dy, dx)
            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x
            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }
        
        // If the touch coordinate is close to center, focus it to the very center at set the color to white
        let whiteThreshold: CGFloat = 10
        var isCenter = false
        if (distance < whiteThreshold) {
            outputCoord.x = wheelLayerCenter.x
            outputCoord.y = wheelLayerCenter.y
            isCenter = true
        }
        return (outputCoord, isCenter)
    }
    
    func update(event: NSEvent, doit: Bool = false) {
    
        let point = self.convert(event.locationInWindow, from: event.window?.contentView)
        print(point)
        let indicator = getIndicatorCoordinate(point)
        let point2 = indicator.point
        var color = (hue: CGFloat(0), saturation: CGFloat(0))
        if !indicator.isCenter  {
            color = hueSaturationAtPoint(CGPoint(x: point2.x*scale, y: point2.y*scale))
        }
        print(color)
        
        self.hue = color.hue
        self.saturation = color.saturation
        
        if doit {
            delegate?.didUpdateColor(hue: color.hue, saturation: color.saturation)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        update(event: event, doit: true)
    }
    
    override func mouseUp(with event: NSEvent) {
        update(event: event, doit: true)
    }
    
    override func mouseDown(with event: NSEvent) {
        update(event: event)
        print(self.convert(event.locationInWindow, from: event.window?.contentView))
    }
    
    func createColorWheel(_ size: CGSize) -> CGImage {
        
        
        // Creates a bitmap of the Hue Saturation wheel
        let originalWidth: CGFloat = size.width
        let originalHeight: CGFloat = size.height
        let dimension: CGFloat = min(originalWidth*scale, originalHeight*scale)
        let bufferLength: Int = Int(dimension * dimension * 4)
        
        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)
        
        for y in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
            for x in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
                var hsv: HSV = (hue: 0, saturation: 0, brightness: 0, alpha: 0)
                var rgb: RGB = (red: 0, green: 0, blue: 0, alpha: 0)
                
                let color = hueSaturationAtPoint(CGPoint(x: x, y: y))
                let hue = color.hue
                let saturation = color.saturation
                var a: CGFloat = 0.0
                if (saturation < 1.0) {
                    // Antialias the edge of the circle.
                    if (saturation > 0.99) {
                        a = (1.0 - saturation) * 100
                    } else {
                        a = 1.0;
                    }
                    
                    hsv.hue = hue
                    hsv.saturation = saturation
                    hsv.brightness = self.brightness
                    hsv.alpha = a
                    rgb = hsv2rgb(hsv)
                }
                let offset = Int(4 * (x + (dimension - y - 1) * dimension))
                bitmap?[offset] = UInt8(rgb.red*255)
                bitmap?[offset + 1] = UInt8(rgb.green*255)
                bitmap?[offset + 2] = UInt8(rgb.blue*255)
                bitmap?[offset + 3] = UInt8(rgb.alpha*255)
            }
        }
        
        // Convert the bitmap to a CGImage
        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let dataProvider: CGDataProvider? = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef: CGImage? = CGImage(width: Int(dimension), height: Int(dimension), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: Int(dimension) * 4, space: colorSpace!, bitmapInfo: bitmapInfo, provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        return imageRef!
    }
    
    func hueSaturationAtPoint(_ position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {

        let c = wheelLayer.frame.width * scale / 2
        let dx = CGFloat(position.x - c) / c
        let dy = CGFloat(position.y - c) / c
        let d = sqrt(CGFloat (dx * dx + dy * dy))
        
        let saturation: CGFloat = d
        
        var hue: CGFloat
        if (d == 0) {
            hue = 0;
        } else {
            hue = atan2(dy, dx) / Double.pi / 2.0
            if hue < 0 {
                hue = hue + 1.0
            }
        }
        return (hue, saturation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private class BrightnessSliderCell: NSSliderCell {
    
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
    }
}

private class SliderBackgroundView: NSView {
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

protocol GrayPanelViewDelegate {
    func didChange(brightness: CGFloat)
}

protocol ColorPanelViewDelegate {
    func didChange(hue: Float, saturation: Float, brightness: Float)
}

class GraySliderPanelView: NSView {
    
    let margin = CGFloat(8)
    
    private let brightnessSlider: NSSlider = NSSlider(frame: .zero)
    private let sliderBackgroudView = SliderBackgroundView(frame: .zero)
    
    var brightness: CGFloat = 0 {
        didSet {
            brightnessSlider.floatValue = 1.0 - Float(brightness)
        }
    }
    
    @IBAction func didchange(sender: NSSlider) {
        print(sender.floatValue)
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
        
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ColorWheelPanelView: NSView, ColorWheelViewDelegate {
    
    var delegate: ColorPanelViewDelegate?
    
    let margin = CGFloat(8)
    
    func didUpdateColor(hue: CGFloat, saturation: CGFloat) {
        sliderBackgroudView.didUpdateColor(hue: hue, saturation: saturation)
        if let delegate = delegate {
            delegate.didChange(hue: Float(colorWheelView.hue), saturation: Float(colorWheelView.saturation), brightness: Float(colorWheelView.brightness))
        }
    }
    
    let brightnessSlider: NSSlider = NSSlider(frame: .zero)
    private let colorWheelView = ColorWheelView(frame: .zero)
    private let sliderBackgroudView = SliderBackgroundView(frame: .zero)
    
    var brightness: CGFloat = 0 {
        didSet {
            colorWheelView.brightness = CGFloat(brightness)
            brightnessSlider.floatValue = 1.0 - Float(brightness)
        }
    }
    
    var hue: CGFloat = 0 {
        didSet {
            sliderBackgroudView.hue = hue
            colorWheelView.hue = hue
        }
    }
    
    var saturation: CGFloat = 0 {
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
        
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
