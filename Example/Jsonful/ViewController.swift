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
        
        //print(snapshot.nsAttributedString.unwrap().as.nsAttributedString.value?.string == "success")
        //print(reference.nsAttributedString.unwrap().as.nsAttributedString.value?.string == "success")
        
        print(snapshot.nsMutableAttributedString.unwrap().as.nsMutableAttributedString.value == nil)
        print(reference.nsMutableAttributedString.unwrap().as.nsMutableAttributedString.value?.string == "success")

    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

