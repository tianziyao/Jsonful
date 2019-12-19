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
        
        public func isAllow(_ element: Any?) -> Bool {
            if element == nil && self.contains(.notNil) {
                return false
            }
            else if element is NSNull && self.contains(.notNull) {
                return false
            }
            else if let data = element as? Containable, self.contains(.notEmpty) {
                return !data.isEmpty
            }
            else {
                return true
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
        
        public init(value: Optional<T>, file: String = #file, line: Int = #line, id: String) {
            let identity = Unwrap.debug { () -> String in
                let cls = String(describing: object_getClass(value))
                return "-----\(file):\(line)-----\nid: \(id)\nrawType: <\(cls)>\n"
            }
            switch value {
            case .none:
                self = .failure(identity: identity, value: nil, reason: "this data is nil")
            case .some(let value):
                self = .success((value, identity))
            }
        }
        
        private static func failure(identity: String, value: Any?, reason: String) -> Result<T> {
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
        
        public func map<O>(_ closure: (T) -> O) -> Result<O> {
            switch self {
            case .failure(let reason):
                return .failure(reason)
            case .success(let arg):
                return .success((closure(arg.value), arg.identity))
            }
        }
        
        public func `as`<O>(closure: (Result<O>.Success) -> Result<O> = {.success($0)}) -> Result<O> {
            return map { (arg) -> Unwrap.Result<O> in
                if let data = arg.value as? O {
                    return closure((data, arg.identity))
                }
                else {
                    return .failure(identity: arg.identity, value: arg.value, reason: "this data is not <\(O.self)>")
                }
            }
        }
        
        public func `as`<O: Containable>() -> Result<O> {
            return `as`(closure: { (arg) -> Result<O> in
                if arg.value.isEmpty {
                    return .failure(identity: arg.identity, value: nil, reason: "this data is empty")
                }
                else {
                    return .success(arg)
                }
            })
        }
        
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

    var string: Unwrap.Result<String> {
        return self.map({ (value) -> String in
            return String(describing: value)
        })
    }

    var number: Unwrap.Result<NSNumber> {
        return self.string.map({ (arg) -> Unwrap.Result<NSNumber> in
            let number = arg.value.decimalNumber
            if number == NSDecimalNumber.notANumber {
                return .failure(identity: arg.identity, value: arg.value, reason: "this data is not a number")
            }
            else {
                return .success((number, arg.identity))
            }
        })
    }
    
    var int: Unwrap.Result<Int> {
        return self.number.map({ (value) -> Int in
            return value.intValue
        })
    }
    
    var double: Unwrap.Result<Double> {
        return self.number.map({ (value) -> Double in
            return value.doubleValue
        })
    }
    
    var bool: Unwrap.Result<Bool> {
        return self.number.map({ (value) -> Bool in
            return value.boolValue
        })
    }
    
    var array: Unwrap.Result<[Jsonful]> {
        return asArray(Any?.self).map({ (data) -> [Jsonful] in
            return data.map({Jsonful.reference($0)})
        })
    }
    
    var dictionary: Unwrap.Result<[AnyHashable: Jsonful]> {
        return asDictionary(Any?.self).map({ (data) -> [AnyHashable: Jsonful] in
            return data.mapValues({Jsonful.reference($0)})
        })
    }
    
}

public extension Unwrap.Result {
    
    var asImage: Unwrap.Result<UIImage> {
        return self.as()
    }
    
    var asColor: Unwrap.Result<UIColor> {
        return self.as()
    }
    
    var asFont: Unwrap.Result<UIFont> {
        return self.as()
    }

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


public extension Unwrap.Result {

    var asString: Unwrap.Result<String> {
        return self.as()
    }

    var asInt: Unwrap.Result<Int> {
        return self.as()
    }

    var asDouble: Unwrap.Result<Double> {
        return self.as()
    }

    var asBool: Unwrap.Result<Bool> {
        return self.as()
    }

    var asError: Unwrap.Result<Error> {
        return self.as()
    }
    
    func asArray<T: Any>(_ type: T.Type = T.self, rule: Unwrap.Rule = .all) -> Unwrap.Result<[T]> {
        if "\(type)".contains("Optional") {
            return self.as()
        }
        else {
            let result: Unwrap.Result<[T?]> = self.as()
            return result.map({$0.filter({rule.isAllow($0)})}).as()
        }
    }
    
    func asDictionary<T: Any>(_ type: T.Type = T.self, rule: Unwrap.Rule = .all) -> Unwrap.Result<[AnyHashable: T]> {
        if "\(type)".contains("Optional") {
            return self.as()
        }
        else {
            let result: Unwrap.Result<[AnyHashable: T?]> = self.as()
            return result.map({$0.filter({rule.isAllow($0)})}).as()
        }
    }
    
    func asSet<T: Hashable>(_ type: T.Type = T.self, rule: Unwrap.Rule = .all) -> Unwrap.Result<Set<T>> {
        if "\(type)".contains("Optional") {
            return self.as()
        }
        else {
            let result: Unwrap.Result<Set<T?>> = self.as()
            return result.map({$0.filter({rule.isAllow($0)})}).as()
        }
    }

    var asDate: Unwrap.Result<Date> {
        return self.as()
    }
    
    var asData: Unwrap.Result<Data> {
        return self.as()
    }
    
    var asRange: Unwrap.Result<Range<Int>> {
        return self.as()
    }
    
    var asURL: Unwrap.Result<URL> {
        return self.as()
    }
}


public extension Unwrap.Result {

    var asCGFloat: Unwrap.Result<CGFloat> {
        return self.as()
    }
    
    var asCGSize: Unwrap.Result<CGSize> {
        return self.as()
    }
    
    var asCGPoint: Unwrap.Result<CGPoint> {
        return self.as()
    }
    
    var asCGRect: Unwrap.Result<CGRect> {
        return self.as()
    }
    
}

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

extension NSURL: Containable {
    public var isEmpty: Bool {
        return (absoluteString ?? "").count == 0
    }
}

public extension Unwrap.Result {
    
    var asNSString: Unwrap.Result<NSString> {
        return self.as()
    }
    
    var asNSMutableString: Unwrap.Result<NSMutableString> {
        return self.as()
    }
    
    var asNSAttributedString: Unwrap.Result<NSAttributedString> {
        return self.as()
    }
    
    var asNSMutableAttributedString: Unwrap.Result<NSMutableAttributedString> {
        return self.as()
    }
    
    var asNSNumber: Unwrap.Result<NSNumber> {
        return self.as()
    }
    
    func asNSArray(rule: Unwrap.Rule = .all) -> Unwrap.Result<NSArray> {
        let result: Unwrap.Result<NSArray> = self.as()
        return result.asArray(Any.self, rule: rule).as()
    }
    
    func asNSMutableArray(rule: Unwrap.Rule = .all) -> Unwrap.Result<NSMutableArray> {
        let result: Unwrap.Result<NSMutableArray> = self.as()
        return result.map { (array) -> NSMutableArray in
            array.filter(using: .init(block: { (value, _) -> Bool in
                return rule.isAllow(value)
            }))
            return array
        }.as()
    }
    
    var asNSPointerArray: Unwrap.Result<NSPointerArray> {
        return self.as()
    }
    
    func asNSDictionary(rule: Unwrap.Rule = .all) ->  Unwrap.Result<NSDictionary> {
        let result: Unwrap.Result<NSDictionary> = self.as()
        return result.asDictionary(Any.self, rule: rule).as()
    }
    
    var asNSMutableDictionary: Unwrap.Result<NSMutableDictionary> {
        return self.as()
    }
    
    var asNSMapTable: Unwrap.Result<NSMapTable<AnyObject, AnyObject>> {
        return self.as()
    }
    
    var asNSSet: Unwrap.Result<NSSet> {
        return self.as()
    }
    
    var asNSMutableSet: Unwrap.Result<NSMutableSet> {
        return self.as()
    }
    
    var asNSHashTable: Unwrap.Result<NSHashTable<AnyObject>> {
        return self.as()
    }
    
    var asNSDate: Unwrap.Result<NSDate> {
        return self.as()
    }
    
    var asNSData: Unwrap.Result<NSData> {
        return self.as()
    }
    
    var asNSRange: Unwrap.Result<NSRange> {
        return self.as()
    }
    
    var asNSObject: Unwrap.Result<NSObject> {
        return self.as()
    }
    
    var asNSURL: Unwrap.Result<NSURL> {
        return self.as()
    }
    
    var asNSBool: Unwrap.Result<ObjCBool> {
        return self.as()
    }
    
    var asNSError: Unwrap.Result<NSError> {
        return self.as()
    }
    
    var asNSValue: Unwrap.Result<NSValue> {
        return self.as()
    }

}

public extension Optional {

    func unwrap(file: String = #file, line: Int = #line, id: String = "") -> Unwrap.Result<Wrapped> {
        return .init(value: self, file: file, line: line, id: id)
    }
}
