//
//  Unwrap.swift
//  Demo
//
//  Created by Tian on 2019/12/3.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

public struct Unwrap {
    
    public struct Rule: OptionSet {
        
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let notNil: Rule = .init(rawValue: 1 << 0)
        public static let notNull: Rule = .init(rawValue: 1 << 1)
        public static let notEmpty: Rule = .init(rawValue: 1 << 2)
        public static let all: Rule = [.notNil, .notNull, .notEmpty]
        
        public func result<T>(value: Optional<T>, identity: String) -> Result<T> {
            let value = Mirror.unwrap(value: value)
            if value == nil && self.contains(.notNil) {
                return .failure(value: value, identity: identity, reason: "this data is nil")
            }
            if value is NSNull && self.contains(.notNull) {
                return .failure(value: value, identity: identity, reason: "this data is null")
            }
            if let data = value as? Containable, self.contains(.notEmpty), data.isEmpty {
                return .failure(value: value, identity: identity, reason: "this data is empty")
            }
            if let data = value {
                return .success((data, identity))
            }
            else {
                return .failure(value: value, identity: identity, reason: "this data is exception")
            }
        }
        

    }
    
    public enum Result<T> {
        
        public typealias Success = (value: T, identity: String)
        
        case success(Success)
        case failure(String)
        
        public var value: T? {
            switch self {
            case .success(let arg):
                return arg.value
            case .failure:
                return nil
            }
        }
        
        public var info: String? {
            switch self {
            case .success:
                return nil
            case .failure(let info):
                return info
            }
        }
        
        public init(value: Optional<T>, id: String, rule: Rule = .all, file: String = #file, line: Int = #line) {
            let identity = Unwrap.debug { () -> String in
                let cls = String(describing: object_getClass(value))
                return "-----\(file):\(line)-----\nid: \(id)\nrawType: <\(cls)>\n"
            }
            self = rule.result(value: value, identity: identity)
        }
        
        internal static func failure(value: Any?, identity: String, reason: String) -> Result<T> {
            let info = Unwrap.debug { () -> String in
                var string: String = ""
                string.append(contentsOf: identity)
                if let value = value {
                    string.append(contentsOf: "rawValue: \(String(describing: value))\n")
                }
                string.append(contentsOf: "reason: \(reason).\n")
                return string
            }
            return .failure(info)
        }
        
        public func map<O>(_ closure: (Result<T>.Success) -> Result<O>) -> Result<O> {
            switch self {
            case .failure(let reason):
                return .failure(reason)
            case .success(let arg):
                return closure(arg)
            }
        }
        
//        public func map<O>(_ closure: (T) -> O) -> Result<O> {
//            switch self {
//            case .failure(let reason):
//                return .failure(reason)
//            case .success(let arg):
//                return .success((closure(arg.value), arg.identity))
//            }
//        }
        
//        public func `as`<O>(closure: (Result<O>.Success) -> Result<O> = {.success($0)}) -> Result<O> {
//            return map { (arg) -> Unwrap.Result<O> in
//                if let data = arg.value as? O {
//                    return closure((data, arg.identity))
//                }
//                else {
//                    return .failure(identity: arg.identity, value: arg.value, reason: "this data is not <\(O.self)>")
//                }
//            }
//        }
//
//        public func `as`<O: Containable>() -> Result<O> {
//            return `as`(closure: { (arg) -> Result<O> in
//                if arg.value.isEmpty {
//                    return .failure(identity: arg.identity, value: nil, reason: "this data is empty")
//                }
//                else {
//                    return .success(arg)
//                }
//            })
//        }
        
        public func then(success: (T) -> (), failure: ((String) -> ())? = nil) {
            switch self {
            case .success(let value, _):
                success(value)
            case .failure(let reason):
                #if DEBUG
                dump(reason)
                #endif
                failure?(reason)
            }
        }
        
    }
    
    public struct As<T> {
        
        private let result: Result<T>
        
        public init(result: Result<T>) {
            self.result = result
        }
        
        public func that<O>(closure: (Result<O>.Success) -> Result<O> = {.success($0)}) -> Result<O> {
            return result.map({ (arg) -> Result<O> in
                if let data = arg.value as? O {
                    return closure((data, arg.identity))
                }
                else {
                    return .failure(value: arg.value, identity: arg.identity, reason: "this data is not <\(O.self)>")
                }
            })
        }
        
        //MARK: ---字符串---
        
        var string: Result<String> {
            return that()
        }
        
        var cfString: Result<CFString> {
            return that()
        }
        
        var nsString: Unwrap.Result<NSString> {
            return that()
        }
        
        var nsMutableString: Unwrap.Result<NSMutableString> {
            return that()
        }
        
        //MARK: ---属性字符串---

        var nsAttributedString: Unwrap.Result<NSAttributedString> {
            return that()
        }
    
        var nsMutableAttributedString: Unwrap.Result<NSMutableAttributedString> {
            return that()
        }
        
        //MARK: ---数字---

        var int: Result<Int> {
            return that()
        }

        var double: Result<Double> {
            return that()
        }
        
        var float: Result<Float> {
            return that()
        }
        
        var nsNumber: Unwrap.Result<NSNumber> {
            return that()
        }
        
        //MARK: ---布尔---

        var bool: Result<Bool> {
            return that()
        }
        
        var objcBool: Unwrap.Result<ObjCBool> {
            return that()
        }
    
        //MARK: ---对象---
        
        var date: Result<Date> {
            return that()
        }
        
        var nsDate: Unwrap.Result<NSDate> {
            return that()
        }
        
        var data: Result<Data> {
            return that()
        }
        
        var nsData: Unwrap.Result<NSData> {
            return that()
        }
        
        var range: Result<Range<Int>> {
            return that()
        }
        
        var nsRange: Unwrap.Result<NSRange> {
            return that()
        }
        
        var url: Result<URL> {
            return that()
        }
        
        var asNSURL: Unwrap.Result<NSURL> {
            return that()
        }
    
        var anyObject: Result<AnyObject> {
            return that()
        }
    
        var nsObject: Unwrap.Result<NSObject> {
            return that()
        }
        
        var error: Result<Error> {
            return that()
        }
        
        var nsError: Unwrap.Result<NSError> {
            return that()
        }
    
        var nsValue: Unwrap.Result<NSValue> {
            return that()
        }


        //MARK: ---UIKit对象---

        var image: Unwrap.Result<UIImage> {
            return that()
        }
    
        var color: Unwrap.Result<UIColor> {
            return that()
        }
    
        var font: Unwrap.Result<UIFont> {
            return that()
        }
        
        //MARK: ---CoreGraphics对象---
        
        var cgFloat: Unwrap.Result<CGFloat> {
            return that()
        }
    
        var cgSize: Unwrap.Result<CGSize> {
            return that()
        }
    
        var cgPoint: Unwrap.Result<CGPoint> {
            return that()
        }
    
        var cgRect: Unwrap.Result<CGRect> {
            return that()
        }
        
        var cgFont: Unwrap.Result<CGFont> {
            return that()
        }
        
        var cgImage: Unwrap.Result<CGImage> {
            return that()
        }
        
        var cgPath: Unwrap.Result<CGPath> {
            return that()
        }
        
        //MARK: ---容器---

        //
        //    func asNSArray(rule: Unwrap.Rule = .all) -> Unwrap.Result<NSArray> {
        //        let result: Unwrap.Result<NSArray> = self.as()
        //        return result.asArray(Any.self, rule: rule).as()
        //    }
        //
        //    func asNSMutableArray(rule: Unwrap.Rule = .all) -> Unwrap.Result<NSMutableArray> {
        //        let result: Unwrap.Result<NSMutableArray> = self.as()
        //        return result.map { (array) -> NSMutableArray in
        //            array.filter(using: .init(block: { (value, _) -> Bool in
        //                return rule.isAllow(value)
        //            }))
        //            return array
        //        }.as()
        //    }
        //
        //    var asNSPointerArray: Unwrap.Result<NSPointerArray> {
        //        return self.as()
        //    }
        //
        //    func asNSDictionary(rule: Unwrap.Rule = .all) ->  Unwrap.Result<NSDictionary> {
        //        let result: Unwrap.Result<NSDictionary> = self.as()
        //        return result.asDictionary(Any.self, rule: rule).as()
        //    }
        //
        //    var asNSMutableDictionary: Unwrap.Result<NSMutableDictionary> {
        //        return self.as()
        //    }
        //
        //    var asNSMapTable: Unwrap.Result<NSMapTable<AnyObject, AnyObject>> {
        //        return self.as()
        //    }
        //
        //    var asNSSet: Unwrap.Result<NSSet> {
        //        return self.as()
        //    }
        //
        //    var asNSMutableSet: Unwrap.Result<NSMutableSet> {
        //        return self.as()
        //    }
        //
        //    var asNSHashTable: Unwrap.Result<NSHashTable<AnyObject>> {
        //        return self.as()
        //    }
        //


        
//        func array<T: Any>(_ type: T.Type = T.self, rule: Unwrap.Rule = .all) -> Unwrap.Result<[T]> {
//            if "\(type)".contains("Optional") {
//                return self.that()
//            }
//            else {
//                let result: Unwrap.Result<[T?]> = self.that()
//                return result.map({$0.filter({rule.isAllow($0)})}).that()
//            }
//        }
//
//        func dictionary<T: Any>(_ type: T.Type = T.self, rule: Unwrap.Rule = .all) -> Unwrap.Result<[AnyHashable: T]> {
//            if "\(type)".contains("Optional") {
//                return self.as()
//            }
//            else {
//                let result: Unwrap.Result<[AnyHashable: T?]> = self.as()
//                return result.map({$0.filter({rule.isAllow($0)})}).as()
//            }
//        }
//
//        func set<T: Hashable>(_ type: T.Type = T.self, rule: Unwrap.Rule = .all) -> Unwrap.Result<Set<T>> {
//            if "\(type)".contains("Optional") {
//                return self.as()
//            }
//            else {
//                let result: Unwrap.Result<Set<T?>> = self.as()
//                return result.map({$0.filter({rule.isAllow($0)})}).as()
//            }
//        }

    }

    public static func merge<O1, O2>(_ r1: Result<O1>, _ r2: Result<O2>) -> Result<(O1, O2)> {
        guard let v1 = r1.value else { return .failure(r1.info ?? "") }
        guard let v2 = r2.value else { return .failure(r2.info ?? "") }
        return .success(((v1, v2), ""))
    }
    
    public static func merge<O1, O2, O3>(_ r1: Result<O1>, _ r2: Result<O2>, _ r3: Result<O3>) -> Result<(O1, O2, O3)> {
        guard let v1 = r1.value else { return .failure(r1.info ?? "") }
        guard let v2 = r2.value else { return .failure(r2.info ?? "") }
        guard let v3 = r3.value else { return .failure(r3.info ?? "") }
        return .success(((v1, v2, v3), ""))
    }
    
    private static func debug(action: () -> String) -> String {
        #if DEBUG
        return action()
        #else
        return ""
        #endif
    }
}

internal extension String {
    
    var decimalNumber: NSDecimalNumber {
        let set = Set(["false", "null", "<null>", "nil", "nan", "undefined", "", "true"])
        let text = self.lowercased()
        if set.contains(text)  {
            return NSDecimalNumber(string: text == "true" ? "1" : "0")
        }
        else {
            return NSDecimalNumber(string: self)
        }
    }
}

public extension Unwrap.Result {

//    var string: Unwrap.Result<String> {
//        return self.map({ (value) -> String in
//            return String(describing: value)
//        })
//    }
//
//    var number: Unwrap.Result<NSNumber> {
//        return self.string.map({ (arg) -> Unwrap.Result<NSNumber> in
//            let number = arg.value.decimalNumber
//            if number == NSDecimalNumber.notANumber {
//                return .failure(identity: arg.identity, value: arg.value, reason: "this data is not a number")
//            }
//            else {
//                return .success((number, arg.identity))
//            }
//        })
//    }
//
//    var int: Unwrap.Result<Int> {
//        return self.number.map({ (value) -> Int in
//            return value.intValue
//        })
//    }
//
//    var double: Unwrap.Result<Double> {
//        return self.number.map({ (value) -> Double in
//            return value.doubleValue
//        })
//    }
//
//    var bool: Unwrap.Result<Bool> {
//        return self.number.map({ (value) -> Bool in
//            return value.boolValue
//        })
//    }
//
//    var array: Unwrap.Result<[Jsonful]> {
//        return asArray(Any?.self).map({ (data) -> [Jsonful] in
//            return data.map({Jsonful.reference($0)})
//        })
//    }
//
//    var dictionary: Unwrap.Result<[AnyHashable: Jsonful]> {
//        return asDictionary(Any?.self).map({ (data) -> [AnyHashable: Jsonful] in
//            return data.mapValues({Jsonful.reference($0)})
//        })
//    }
    
}



public protocol Containable {
    var isEmpty: Bool { get }
}

extension String: Containable {}

extension Array: Containable {}

extension Dictionary: Containable {}

extension Set: Containable {}

extension Data: Containable {}

extension Range: Containable {}

extension NSString: Containable {
    public var isEmpty: Bool {
        return length <= 0
    }
}

extension NSAttributedString: Containable {
    public var isEmpty: Bool {
        return length <= 0
    }
}

extension NSArray: Containable {
    public var isEmpty: Bool {
        return count <= 0
    }
}

extension NSPointerArray: Containable {
    public var isEmpty: Bool {
        return count <= 0
    }
}

extension NSDictionary: Containable {
    public var isEmpty: Bool {
        return count <= 0
    }
}

@objc extension NSMapTable: Containable {
    public var isEmpty: Bool {
        return count <= 0
    }
}

extension NSSet: Containable {
    public var isEmpty: Bool {
        return count <= 0
    }
}

@objc extension NSHashTable: Containable {
    public var isEmpty: Bool {
        return count <= 0
    }
}

extension NSData: Containable {
    public var isEmpty: Bool {
        return length <= 0
    }
}

extension NSRange: Containable {
    public var isEmpty: Bool {
        return length <= 0
    }
}


public extension Optional {

    func unwrap(file: String = #file, line: Int = #line, id: String = "") -> Unwrap.Result<Wrapped> {
        return .init(value: self, id: id, file: file, line: line)
    }
}
