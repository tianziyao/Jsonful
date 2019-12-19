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
        
        let dic = NSMutableDictionary(dictionary: ["a": 1, "b": NSNull()])
        
        var ss: NSDictionary? = Unwrap.Result(value: dic, id: "").as().that
        
        print(dic)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension UIViewController {
    
}
