//
//  Mock.swift
//  Jsonful_Example
//
//  Created by Tian on 2019/12/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct Index: OptionSet, Hashable {
    
    static let zero = Index(rawValue: 0)
    
    let rawValue: Int
    
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

struct Object: Hashable {
    let index: Index = .zero
    var name: StringEnum = .max
    var age: IntEnum = .one
}

enum IntEnum: Int {
    case zero = 0
    case one = 1
    case two = 2
}

enum StringEnum: String {
    case rock, max, penny
}

enum Enum {
    case tuple(String, Object)
    case parameter(name: String, age: Int)
    case int(IntEnum)
}


class Mock {
    var int: Enum??? = .int(.zero)
    var tuple: Enum??? = .tuple("string", Object())
    var parameter: Enum? = .parameter(name: "rock", age: 22)
    var dic: [AnyHashable: Any?] = ["int": 100, "tuple": (number: 100), "string": nil]
    var arr: [Any?] = [100, (a: "a", b: "b"), nil]
    var set = Set<AnyHashable?>([100, "200", Object(), nil])
}
