import Cocoa
import PlaygroundSupport
import ColorWheelPanelView
import SwiftUI

struct ColorWheelPanelViewSwiftUI: NSViewRepresentable {
    typealias NSViewType = ColorWheelPanelView
    
    @Binding private var brightness: Double
    @Binding private var saturation: Double
    @Binding private var hue: Double
    @Binding private var isContinuous: Bool

    init(hue: Binding<Double>, saturation: Binding<Double>, brightness: Binding<Double>, continuous: Binding<Bool>) {
        self._brightness = brightness
        self._hue = hue
        self._saturation = saturation
        self._isContinuous = continuous
    }

    func makeNSView(context: Context) -> ColorWheelPanelView {
        let view = ColorWheelPanelView()
        view.delegate = context.coordinator
        return view
    }
    
    func updateNSView(_ nsView: ColorWheelPanelView, context: Context) {
        nsView.brightness = brightness / 100.0
        nsView.saturation = saturation / 100.0
        nsView.hue = hue / 100.0
        nsView.isContinuous = isContinuous
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ColorWheelPanelViewDelegate {
        var parent: ColorWheelPanelViewSwiftUI

        init(_ parent: ColorWheelPanelViewSwiftUI) {
            self.parent = parent
        }

        func didChangeColor(hue: Double, saturation: Double, brightness: Double) {
            self.parent.brightness = brightness * 100
            self.parent.saturation = saturation * 100
            self.parent.hue = hue * 100
        }
    }

}


struct GraySliderPanelViewSwiftUI: NSViewRepresentable {
    typealias NSViewType = GraySliderPanelView
    
    @Binding private var brightness: Double
    @Binding private var isContinuous: Bool

    init(brightness: Binding<Double>, continuous: Binding<Bool>) {
        self._brightness = brightness
        self._isContinuous = continuous
    }

    func makeNSView(context: Context) -> GraySliderPanelView {
        let view = GraySliderPanelView()
        view.delegate = context.coordinator
        return view
    }
    
    func updateNSView(_ nsView: GraySliderPanelView, context: Context) {
        nsView.brightness = brightness / 100.0
        nsView.isContinuous = isContinuous
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GraySliderPanelViewDelegate {
        var parent: GraySliderPanelViewSwiftUI

        init(_ parent: GraySliderPanelViewSwiftUI) {
            self.parent = parent
        }
        
        func didChangeColor(brightness: Double) {
            self.parent.brightness = brightness * 100
        }
    }

}

struct ContentView: View {
    @State var c_hueValue : Double = 0
    @State var c_saturationValue : Double = 0
    @State var c_brightnessValue : Double = 0
    @State var c_isContinuousValue : Bool = false
    
    @State var g_brightnessValue : Double = 0
    @State var g_isContinuousValue : Bool = false
    
    var body: some View {
        Spacer(minLength: 20)
        VStack(spacing: 15) {
            Text("ColorWheelPanelView")
            ColorWheelPanelViewSwiftUI(hue: $c_hueValue, saturation: $c_saturationValue, brightness: $c_brightnessValue, continuous: $c_isContinuousValue)
            Slider(value: $c_hueValue, in: 0...100) {
                Text("Hue")
            }
            Slider(value: $c_saturationValue, in: 0...100) {
                Text("Saturation")
            }
            Slider(value: $c_brightnessValue, in: 0...100) {
                Text("Brightness")
            }
            Toggle("Continuous", isOn: $c_isContinuousValue)
        }
        Spacer(minLength: 60)
        VStack(spacing: 15) {
            Text("GraySliderPanelView")
            GraySliderPanelViewSwiftUI(brightness: $g_brightnessValue, continuous: $g_isContinuousValue)
            Slider(value: $g_brightnessValue, in: 0...100) {
                Text("Brightness")
            }
            Toggle("Continuous", isOn: $g_isContinuousValue)
        }
        Spacer(minLength: 40)
    }
}

let view = ContentView()
PlaygroundPage.current.setLiveView(view)
