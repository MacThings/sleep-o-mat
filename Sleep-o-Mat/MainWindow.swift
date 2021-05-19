//
//  ViewController.swift
//  Sleep-o-Mat
//
//  Created by Prof. Dr. Luigi on 19.05.21.
//

import Cocoa

class MainWindow: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

