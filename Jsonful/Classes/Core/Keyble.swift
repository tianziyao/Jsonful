//
//  Keyble.swift
//  Demo
//
//  Created by Tian on 2019/12/13.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

internal protocol JsonfulKeyble {
    var describe: String { get }
    func fetch(from any: Any?, prefixes: [String]) -> Any?
}

extension Int: JsonfulKeyble {

    var describe: String {
        return "[\(self)]"
    }
    
    func fetch(from any: Any?, prefixes: [String]) -> Any? {
        guard let array = any as? [Any] else { return nil }
        return array.indices.contains(self) ? array[self] : nil
    }
}

extension String: JsonfulKeyble {

    var describe: String {
        return ".\(self)"
    }
    
    func fetch(from dic: [AnyHashable: Any], keys: Set<AnyHashable>) -> Any? {
        return dic.filter({keys.contains($0.key)}).first?.value
    }
    
    func fetch(from obj: NSObject) -> Any? {
        return obj.responds(to: Selector(self)) ? obj.value(forKey: self) : nil
    }
    
    func fetch(from value: Any, keys: Set<AnyHashable>) -> Any? {
        let child = Mirror(reflecting: value).children.filter({keys.contains($0.label ?? "")})
        guard let value = child.first?.value else { return nil }
        let mirror = Mirror(reflecting: value)
        guard mirror.displayStyle == .optional else { return value }
        guard mirror.children.count != 0 else { return value }
        return mirror.children.first?.value
    }
    
    func fetch(from any: Any?, prefixes: [String]) -> Any? {
        guard let any = any else { return nil }
        var keys = Set(prefixes.map({"\($0)\(self)"}))
        keys.update(with: self)
        if let dic = any as? [AnyHashable: Any], let result = fetch(from: dic, keys: keys) {
            return Mirror.unwrap(value: result)
        }
        else if let value = fetch(from: any, keys: keys) {
            return value
        }
        else if let obj = any as? NSObject, let result = fetch(from: obj) {
            return Mirror.unwrap(value: result)
        }
        else {
            return nil
        }
    }
    
}
