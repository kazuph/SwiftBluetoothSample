//
//  ViewController.swift
//  SwiftLGBluetooth
//
//  Created by 本間和弘 on 2015/10/26.
//  Copyright © 2015年 Kazuhiro Homma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLEManager.sharedInstance.scanBeacon()
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: NSBlockOperation(block: { () -> Void in
            BLEManager.sharedInstance.scanBeacon()
        }), selector: Selector("main"), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

