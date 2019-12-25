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
    var tupleOrNil: (status: String???, code: Int?)?

    var dictionary: [AnyHashable: Any]
    var dictionaryOrNil: [AnyHashable: Any??]?

    let nsDictionary: NSDictionary
    let nsDictionaryOrNil: NSDictionary?
    let nsMutableDictionary: NSMutableDictionary

    var array: [Any]
    var arrayOrNil: [Any???]

    let nsArray: NSArray
    let nsArrayOrNil: NSArray?
    let nsMutableArray: NSMutableArray

    var set: Set<AnyHashable>
    var setOrNil: Set<AnyHashable??>?

    let nsSet: NSSet
    let nsSetOrNil: NSSet?
    let nsMutableSet: NSMutableSet
    
    var string: String
    var nsString: NSString
    let nsMutableString: NSMutableString
    
    var nsAttributedString: NSAttributedString
    let nsMutableAttributedString: NSMutableAttributedString
    
    init() {
        self.tuple = ("success", 200)
        self.tupleWithPropertyName = ("success", 200)
        self.tupleOrNil = (nil, 404)
        
        self.dictionary = ["key": "value"]
        self.dictionaryOrNil = ["key": "value", "nil": nil]
        
        self.nsDictionary = .init(dictionary: ["key": "value"])
        self.nsDictionaryOrNil = .init(dictionary: ["key": "value", "null": NSNull()])
        self.nsMutableDictionary = .init(dictionary: self.nsDictionary)
        
        self.array = [500, 501, 502]
        self.arrayOrNil = [nil, 501, 502]
        
        self.nsArray = .init(array: [500, 501, 502])
        self.nsArrayOrNil = .init(array: [NSNull(), 501, 502])
        self.nsMutableArray = .init(array: self.array)
        
        self.set = .init([500, 501, 502])
        self.setOrNil = .init([NSNull(), 501, 502])

        self.nsSet = .init(array: [500, 501, 502])
        self.nsSetOrNil = .init(array: [NSNull(), 501, 502])
        self.nsMutableSet = .init(array: self.array)
        
        self.string = "success"
        self.nsString = "success"
        self.nsMutableString = "success"
        
        self.nsAttributedString = .init(string: "success")
        self.nsMutableAttributedString = .init(string: "success")
    }
}
