//
//  ViewController.swift
//  Jsonful
//
//  Created by tianziyao on 12/16/2019.
//  Copyright (c) 2019 tianziyao. All rights reserved.
//

import UIKit
import Jsonful




extension AppDelegate {
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }
    
}

class ViewController: UIViewController {


    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let mock = Jsonful.snapshot(Mock())

        let nsArray = mock.nsArrayOrNil
        print(nsArray[0].unwrap().value)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension UIViewController {
    
}
