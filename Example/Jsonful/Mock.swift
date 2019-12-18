//
//  Mock.swift
//  Jsonful_Example
//
//  Created by Tian on 2019/12/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class Mock {
    
    var tuple: (String, Int)
    var tupleWithPropertyName: (status: String, code: Int)
    var tupleOrNil: (status: String?, code: Int?)?

    var dictionary: [AnyHashable: Any]
    var dictionaryOrNil: [AnyHashable: Any?]?

    var nsDictionary: NSDictionary
    var nsDictionaryOrNil: NSDictionary?

    var array: [Any]
    var arrayOrNil: [Any?]

    var nsArray: NSArray
    var nsArrayOrNil: NSArray?

    var set: Set<AnyHashable>
    var setOrNil: Set<AnyHashable?>?

    var nsSet: NSSet
    var nsSetOrNil: NSSet?
    
    init() {
        self.tuple = ("success", 200)
        self.tupleWithPropertyName = ("success", 200)
        self.tupleOrNil = (nil, 404)
        
        self.dictionary = ["key": "value"]
        self.dictionaryOrNil = ["key": "value", "nil": nil]
        
        self.nsDictionary = .init(dictionary: ["key": "value"])
        self.nsDictionaryOrNil = .init(dictionary: ["key": "value", "null": NSNull()])
        
        self.array = [500, 501, 502]
        self.arrayOrNil = [nil, 501, 502]
        
        self.nsArray = .init(array: [500, 501, 502])
        self.nsArrayOrNil = .init(array: [NSNull(), 501, 502])

        self.set = .init([500, 501, 502])
        self.setOrNil = .init([NSNull(), 501, 502])

        self.nsSet = .init(array: [500, 501, 502])
        self.nsSetOrNil = .init(array: [NSNull(), 501, 502])
        
    }
}
