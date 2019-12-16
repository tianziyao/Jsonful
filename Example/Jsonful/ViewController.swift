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
    
    var mock = Mock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        snapshot()
//        print("---------------------")
//        reference()
        
        unwrap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func unwrap() {
        let data = Jsonful.reference(mock)
        data.set.unwrap().asSet().then(success: { value in
            print(value)
        })
    }

    func reference() {
        var data = Jsonful.reference(mock)
        

        
        print(data.int.int.current)
        print(data.tuple.tuple.0.current)

        let object = data.tuple.tuple.1
        print(object.index.rawValue.current)
        print(object.name.current)
        print(object.age.current)

        let parameter = data.parameter.parameter
        print(parameter.name.current)
        print(parameter.age.current)

        print(data.dic.int.current)
        print(data.dic.tuple.current)
        print(data.dic.string.current)

        print(data.arr[0].current)
        print(data.arr[1].a.current)
        print(data.arr[2].current)
        print(data.arr[3].current)
        
        print(data.set.current)
    }
    
    func snapshot() {
        let data = Jsonful.snapshot(mock)
        
        mock.dic["string"] = "hello"
        mock.arr[2] = StringEnum.penny
        mock.arr.append("wow")
        mock.set.remove(nil)
        
        print(data.int.int.current)
        print(data.tuple.tuple.0.current)
        
        let object = data.tuple.tuple.1
        print(object.index.rawValue.current)
        print(object.name.current)
        print(object.age.current)
        
        let parameter = data.parameter.parameter
        print(parameter.name.current)
        print(parameter.age.current)
        
        print(data.dic.int.current)
        print(data.dic.tuple.current)
        print(data.dic.string.current)
        
        print(data.arr[0].current)
        print(data.arr[1].a.current)
        print(data.arr[2].current)
        print(data.arr[3].current)
        
        print(data.set.current)
    }
}

