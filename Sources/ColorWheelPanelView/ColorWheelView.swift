//
//  File.swift
//  
//
//  Created by Yuichi Yoshida on 2022/04/21.
//

import Cocoa

internal protocol ColorWheelViewDelegate {
    func didUpdateColor(hue: CGFloat, saturation: CGFloat)
}

internal class ColorWheelView: NSView {
    
    var delegate: ColorWheelViewDelegate?
    
    let wheelLayer = CALayer()
    let borderLayer = CAShapeLayer()
    
    var isContinuous = false
    
    let scope = NSImageView(image: NSImage(systemSymbolName: "scope", accessibilityDescription: nil)!)
    
    func updateColorWheel() {
        if wheelLayer.frame.size.width > 0 {
            wheelLayer.contents = createColorWheel(wheelLayer.frame.size)
        }
    }
    
    func updateScopePosition() {
        let radius = wheelLayer.frame.width / 2
        let x = cos(hue * Double.pi * 2) * saturation * radius + radius
        let y = sin(hue * Double.pi * 2) * saturation * radius + radius
        var rect = self.scope.frame
        rect.origin = CGPoint(x: x - rect.size.width/2, y: y - rect.size.height/2)
        self.scope.frame = rect
    }
    
    var brightness = CGFloat(1) {
        didSet {
            updateColorWheel()
        }
    }
    
    var hue = CGFloat(0) {
        didSet {
            updateScopePosition()
        }
    }
    
    var saturation = CGFloat(0) {
        didSet {
            updateScopePosition()
        }
    }
    
    let scale: CGFloat = NSScreen.main!.backingScaleFactor
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.allowedTouchTypes = .direct
        
        self.layer?.addSublayer(wheelLayer)
        self.layer?.addSublayer(borderLayer)
        self.addSubview(scope)
//        self.layer?.backgroundColor = NSColor.green.cgColor
    }
    
    override func layout() {
        super.layout()
        borderLayer.path = NSBezierPath(ovalIn: CGRect(x: 1, y: 1, width: self.frame.width-2, height: self.frame.height-2)).cgPath
        borderLayer.fillColor = CGColor.clear
        borderLayer.strokeColor = CGColor.init(gray: 0.4, alpha: 1.0)
        borderLayer.lineWidth = 1
        wheelLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        updateColorWheel()
        updateScopePosition()
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
    
    func update(event: NSEvent, isContinuous: Bool = false) {
    
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
        
        if isContinuous {
            delegate?.didUpdateColor(hue: color.hue, saturation: color.saturation)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        update(event: event, isContinuous: isContinuous)
    }
    
    override func mouseUp(with event: NSEvent) {
        update(event: event, isContinuous: true)
    }
    
    override func mouseDown(with event: NSEvent) {
        update(event: event, isContinuous: isContinuous)
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
