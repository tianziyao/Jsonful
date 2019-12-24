//
//  ViewController.swift
//  Jsonful
//
//  Created by tianziyao on 12/16/2019.
//  Copyright (c) 2019 tianziyao. All rights reserved.
//

import UIKit
import Jsonful

struct Name {
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)

        mock.string = "fail"
        print(snapshot.string.unwrap().as.string.value == "success")
        print(reference.string.unwrap().as.string.value == "fail")

        mock.nsString = ""
        print(snapshot.nsString.unwrap().as.nsString.value == "success")
        print(reference.nsString.unwrap().as.nsString.value == nil)

        mock.nsMutableString.append("200")

        snapshot.nsMutableString.unwrap().as.nsMutableString.success { (value) in
            print(value == "success")
            value.deleteCharacters(in: .init(location: 0, length: value.length))
            print(mock.nsMutableString == "success200")
        }

//        reference.nsMutableString.unwrap().as.nsMutableString.success { (value) in
//            print(value == "success200")
//            value.deleteCharacters(in: .init(location: 0, length: value.length))
//            print(mock.nsMutableString == "")
//        }

        let ss: NSMutableString = "123"
        
        let rr = Mirror.parse(value: Name())
    
        print(rr)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

