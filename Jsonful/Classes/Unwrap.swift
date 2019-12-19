//
//  Unwrap.swift
//  Demo
//
//  Created by Tian on 2019/12/3.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

public struct Unwrap {
    
//    public struct Rule: OptionSet {
//
//        public var rawValue: Int
//
//        public init(rawValue: Int) {
//            self.rawValue = rawValue
//        }
//
//        public static let notNil: Rule = .init(rawValue: 1 << 0)
//        public static let notNull: Rule = .init(rawValue: 1 << 1)
//        public static let notEmpty: Rule = .init(rawValue: 1 << 2)
//        public static let all: Rule = [.notNil, .notNull, .notEmpty]
//
//        public func result<T>(value: Optional<T>, identity: String) -> Result<T> {
//            let validate = self.validate(value: value)
//            if let data = validate.data {
//                return .success((data, identity))
//            }
//            else {
//                return .failure(value: value, identity: identity, reason: validate.reason)
//            }
//        }
//
//        public func validate<T>(value: Optional<T>) -> (data: Optional<T>, reason: String) {
//            let value = Mirror.unwrap(value: value)
//            if value == nil && self.contains(.notNil) {
//                return (nil, "this data is nil")
//            }
//            if value is NSNull && self.contains(.notNull) {
//                return (nil, "this data is null")
//            }
//            if let data = value as? Containable, self.contains(.notEmpty), data.isEmpty {
//                return (nil, "this data is empty")
//            }
//            if let data = value {
//                return (data, "success")
//            }
//            else {
//                return (nil, "this data is exception")
//            }
//        }
//
//    }
//
   
    
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
    
    internal static func debug(action: () -> String) -> String {
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





public extension Optional {

    func unwrap(file: String = #file, line: Int = #line, id: String = "") -> Unwrap.Result<Wrapped> {
        return .init(value: self, id: id, file: file, line: line)
    }
}
