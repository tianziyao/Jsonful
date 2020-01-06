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
        guard let array = any as? [Any] else {
            return nil
        }
        return array.indices.contains(self) ? array[self] : nil
    }
}

extension String: JsonfulKeyble {

    var describe: String {
        return ".\(self)"
    }
    
    func fetch(dic: [AnyHashable: Any], keys: Set<String>) -> Any? {
        return dic.filter({ keys.contains($0.key as? String ?? "") }).first?.value
    }
    
    func fetch(obj: NSObject) -> Any? {
        return obj.responds(to: Selector(self)) ? obj.value(forKey: self) : nil
    }
    
    func fetch(value: Any, keys: Set<String>) -> Any? {
        let child = Mirror(reflecting: value).children.filter({ keys.contains($0.label ?? "") })
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
        if let dic = any as? [AnyHashable: Any], let result = fetch(dic: dic, keys: keys) {
            return result
        }
        else if let value = fetch(value: any, keys: keys) {
            return value
        }
        else if let obj = any as? NSObject, let result = fetch(obj: obj) {
            return result
        }
        else {
            return nil
        }
    }
    
}
