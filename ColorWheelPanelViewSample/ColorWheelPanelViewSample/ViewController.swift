//
//  ViewController.swift
//  ColorWheelPanelViewSample
//
//  Created by Yuichi Yoshida on 2022/04/20.
//

import Cocoa
import ColorWheelPanelView

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = ColorWheelPanelView()
        
        v.frame = NSRect(x: 0, y: 0, width: 300, height: 350)
        
        self.view.addSubview(v)

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

