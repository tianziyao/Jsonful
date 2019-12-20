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
        
        let dic = NSMutableDictionary(dictionary: ["1": "a", "2": "b", "3": "c"])
        var i = 0
        for kv in dic {
            //dic.removeObject(forKey: kv.key)
            dic.setValue("eee", forKey: "2\(i)")
            i += 1
        }

        print(dic)
        
//        var dic = ["1": "a", "2": "b", "3": "c"]
//
//        var i = 0
//        for kv in dic {
//            //dic.removeObject(forKey: kv.key)
//            dic["e\(i)"] = "eee"
//            i += 1
//        }
//
//        print(dic)

    }
    
    func ddd(any: Any?) {

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension UIViewController {
    
}
