//
//  ViewController.swift
//  Jsonful
//
//  Created by tianziyao on 12/16/2019.
//  Copyright (c) 2019 tianziyao. All rights reserved.
//

import UIKit
import Jsonful
import CoreData
import CoreML
import CoreNFC
import CoreMIDI
import CoreText
import CoreAudio
import CoreImage
import CoreMedia
import CoreMotion
import CoreAudioKit
import CoreLocation
import CoreServices
import CoreBluetooth
import CoreSpotlight
import CoreTelephony
import MobileCoreServices
import JavaScriptCore

@objcMembers class Name {
     var s: String = "123"
}

struct FFF {
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        print(snapshot.int.lint().as.int.value == 0)
        print(snapshot.double.lint().as.double.value == 0)
        print(snapshot.float.lint().as.float.value == 0)
        print(snapshot.nsNumber.lint().as.nsNumber.value == 0)
        
        print(snapshot.bool.lint().as.bool.value == true)
        print(snapshot.objcBool.lint().as.objcBool.value?.boolValue == true)
        
        print(snapshot.date.lint().as.date.value?.timeIntervalSince1970 == 0)
        print(snapshot.nsDate.lint().as.nsDate.value?.timeIntervalSince1970 == 0)

        print(snapshot.data.lint().as.data.value?.count == 10)
        print(snapshot.nsData.lint().as.nsData.value?.length == 10)
        print(snapshot.nsMutableData.lint().as.nsMutableData.value?.length == 10)

        mock.date = Date(timeIntervalSince1970: 100)
        print(reference.date.lint().as.date.value?.timeIntervalSince1970 == 100)

        mock.nsDate = NSDate(timeIntervalSince1970: 100)
        print(reference.nsDate.lint().as.nsDate.value?.timeIntervalSince1970 == 100)


        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func uind() {
        
    }
    
}


