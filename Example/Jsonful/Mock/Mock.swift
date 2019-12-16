//
//  Mock.swift
//  Jsonful_Example
//
//  Created by Tian on 2019/12/16.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

typealias NormalTuple = (String, Object)

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


