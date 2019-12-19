//
//  ViewController.swift
//  Jsonful
//
//  Created by tianziyao on 12/16/2019.
//  Copyright (c) 2019 tianziyao. All rights reserved.
//

import UIKit
import Jsonful

extension NSMutableDictionary {
    
    func filted() {
        
    }
}

class ViewController: UIViewController {


    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arr: [Any?] = [1, nil, NSNull()]
        let arr2 = arr as NSArray

        let arr3 = NSArray(array: [NSNull(), NSNull()]) as? [Any?]
        ddd(any: arr3?[1])

    }
    
    func ddd(any: Any?) {
        if any is NSNull {
            print(222)
        }
        if any == nil {
            print(333)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension UIViewController {
    
}
