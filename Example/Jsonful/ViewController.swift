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


struct FFF {
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mock = Mock()
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        print(snapshot.nsDictionaryOrNil.lint().as.nsDictionary(filter: .nil).value?.count == 1)
        print(reference.nsDictionaryOrNil.lint().as.nsDictionary(filter: .nil).value?.count == 1)

        //0x0000600002f6eb00 0x0000600002f32b40
//        let mock = Mock()
//
//        let reference = Jsonful.reference(mock)
//        let snapshot = Jsonful.snapshot(mock)
//
//
//
//
//
//
//
//
//        print(snapshot.image.lint().as.image.value?.size != .zero)
//        print(snapshot.color.lint().as.color.value == .red)
//        print(snapshot.font.lint().as.font.value?.pointSize == 16)
//
//        print(snapshot.cgFloat.lint().as.cgFloat.value == 100)
//        print(snapshot.cgSize.lint().as.cgSize.value == .zero)
//        print(snapshot.cgPoint.lint().as.cgPoint.value == .zero)
//        print(snapshot.cgRect.lint().as.cgRect.value == .zero)
        
    
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func uind() {
        
    }
    
}


