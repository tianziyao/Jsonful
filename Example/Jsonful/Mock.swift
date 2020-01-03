//
//  Mock.swift
//  Jsonful_Example
//
//  Created by Tian on 2019/12/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    static func from(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

enum Raw {
    case tuple(String, Int)
    case tupleWithPropertyName(status: String, code: Int)
}

enum Number: Int {
    case zero, one, two
}

enum Text: String {
    case a, b, c
}

struct Enum {
    var a: Text = .a
    var zero: Number = .zero
    var tuple: Raw = .tuple("success", 200)
    var tupleWithPropertyName: Raw = .tupleWithPropertyName(status: "success", code: 200)
}

class Mock {
    
    var tuple: (String, Int)
    var tupleWithPropertyName: (status: String, code: Int)
    var tupleOrNil: (status: String???, code: Int?)?
    
    var `enum` = Enum()
    
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
    
    //MARK: ---字符串---
    
    var string: String
    
    var nsString: NSString
    
    var nsMutableString: NSMutableString
    
    //MARK: ---属性字符串---
    
    var nsAttributedString: NSAttributedString
    
    var nsMutableAttributedString: NSMutableAttributedString
    
    //MARK: ---数字---
    
    var int: Int
    
    var double: Double
    
    var float: Float
    
    var nsNumber: NSNumber
    
    //MARK: ---布尔---
    
    var bool: Bool
    
    var objcBool: ObjCBool
    
    //MARK: ---对象---
    
    var date: Date
    
    var nsDate: NSDate
    
    var data: Data
    
    var nsData: NSData
    
    var nsMutableData: NSMutableData
    
    var range: Range<Int>
    
    var closedRange: ClosedRange<Int>

    var nsRange: NSRange
    
    var url: URL
    
    var nsURL: NSURL
    
    var urlRequest: URLRequest
    
    var nsURLRequest: NSURLRequest
    
    var nsMutableURLRequest: NSMutableURLRequest
    
    var anyObject: AnyObject
    
    var nsObject: NSObject
    
    var nsError: NSError
    
    var nsValue: NSValue
    
    
    //MARK: ---UIKit对象---
    
    var _image: UIImage
    
    var _color: UIColor
    
    var _font: UIFont
    
    //MARK: ---CoreGraphics对象---
    
    var cgFloat: CGFloat
    
    var cgSize: CGSize
    
    var cgPoint: CGPoint
    
    var cgRect: CGRect


    init() {
        self.tuple = ("success", 200)
        self.tupleWithPropertyName = ("success", 200)
        self.tupleOrNil = (nil, 404)
        
        self.dictionary = ["status": "success"]
        self.dictionaryOrNil = ["status": "success", "code": nil]
        
        self.nsDictionary = .init(dictionary: ["status": "success"])
        self.nsDictionaryOrNil = .init(dictionary: ["status": "success", "code": NSNull()])
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
        
        self.int = 0
        self.double = 0.0
        self.float = 0.0
        self.nsNumber = NSNumber(value: 0)
        
        self.bool = true
        self.objcBool = true
        
        self.date = Date(timeIntervalSince1970: 0)
        self.nsDate = NSDate(timeIntervalSince1970: 0)
        
        self.data = Data(repeating: 0, count: 10)
        self.nsData = NSData(data: data)
        self.nsMutableData = NSMutableData(data: data)
        
        self.nsRange = NSRange(location: 10, length: 10)
        self.range = Range(self.nsRange)!
        self.closedRange = 0 ... 100
        
        self.url = URL(fileURLWithPath: "mock")
        self.nsURL = NSURL(fileURLWithPath: "mock")
        
        self.urlRequest = URLRequest(url: url)
        self.nsURLRequest = NSURLRequest(url: nsURL as URL)
        self.nsMutableURLRequest = NSMutableURLRequest(url: url)
        
        self.anyObject = NSObject()
        self.nsObject = NSObject()
        
        self.nsError = NSError()
        
        self.nsValue = NSValue(cgSize: .zero)
        
        self._image = UIImage(named: "icon")!
        self._color = .red
        self._font = .systemFont(ofSize: 16)
        
        self.cgFloat = 0
        self.cgSize = .zero
        self.cgPoint = .zero
        self.cgRect = .zero

    }
}


