# ColorWheelPanelView

Color picker view with a color wheel for macOS in Swift.

<img src="https://user-images.githubusercontent.com/33768/164443728-e288aa99-3965-422e-bd67-5eec95f986e4.gif" width="400px">

## How to use

```
import ColorWheelPanelView

let panelView = ColorWheelPanelView()
view.addSubview(panelView)
panelView.frame = NSRect(x: 0, y: 0, width: 300, height: 200)
panelView.delegate = self
panelView.isContinuous = true
```

## License
ColorWheelPanelView is available under the MIT license. See the LICENSE file for more info.
