//
//  Unwrap.swift
//  Demo
//
//  Created by Tian on 2019/12/3.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

public struct Unwrap {

    public static func merge<O1, O2>(_ r1: Result<O1>, _ r2: Result<O2>) -> Result<(O1, O2)> {
        guard let v1 = r1.value else { return .failure(r1.message ?? "") }
        guard let v2 = r2.value else { return .failure(r2.message ?? "") }
        return .success(((v1, v2), ""))
    }
    
    public static func merge<O1, O2, O3>(_ r1: Result<O1>, _ r2: Result<O2>, _ r3: Result<O3>) -> Result<(O1, O2, O3)> {
        guard let v1 = r1.value else { return .failure(r1.message ?? "") }
        guard let v2 = r2.value else { return .failure(r2.message ?? "") }
        guard let v3 = r3.value else { return .failure(r3.message ?? "") }
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

public extension String {
    
    internal var decimalNumber: NSDecimalNumber {
        let text = self.lowercased()
        if String.invalidSet.contains(text)  {
            return NSDecimalNumber(string: text == "true" ? "1" : "0")
        }
        else {
            return NSDecimalNumber(string: self)
        }
    }
    
    public static var invalidSet: Set = Set(["false", "null", "<null>", "nil", "nan", "undefined", "true"])
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
                return .failure(value: arg.value, identity: arg.identity, reason: "this data is not a number")
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
        return self.as.array(Any.self, predicate: nil).map({$0.map({Jsonful.reference($0)})})
    }

    var jsonful: Unwrap.Result<Jsonful> {
        return self.map({Jsonful.reference($0)})
    }
    
}

public extension Optional {

    func unwrap(id: String = "", predicate: Unwrap.Predicate = .exception, file: String = #file, line: Int = #line) -> Unwrap.Result<Wrapped> {
        return .init(value: self, id: id, predicate: predicate, file: file, line: line)
    }
}
