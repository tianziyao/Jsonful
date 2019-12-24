//
//  ViewController.swift
//  Jsonful
//
//  Created by tianziyao on 12/16/2019.
//  Copyright (c) 2019 tianziyao. All rights reserved.
//

import UIKit
import Jsonful

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let mock = Jsonful.snapshot(Mock())
//        print(mock.raw)
//        let tuple = mock.tuple
//        print(tuple.0.unwrap())
////        print(tuple.1.unwrap().as.int.value == 200)
//
        var s: String???? = "3"
        print(s.unwrap().value)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

