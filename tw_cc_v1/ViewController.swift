//
//  ViewController.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 19.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var info = DeviceInfo().getAllInformation()
        print(info)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

