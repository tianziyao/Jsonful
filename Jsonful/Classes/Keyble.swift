//
//  Keyble.swift
//  Demo
//
//  Created by Tian on 2019/12/13.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

public protocol JsonfulKeyble {
    var describe: String { get }
    var hashable: AnyHashable { get }
    func fetch(from any: Any?) -> Any?
}

extension Int: JsonfulKeyble {
    
    public func fetch(from any: Any?) -> Any? {
        guard let array = any as? [Any] else {
            return nil
        }
        guard self < array.count else {
            return nil
        }
        return array[self]
    }
    
    public var hashable: AnyHashable {
        return self
    }
    
    public var describe: String {
        return "[\(self)]"
    }
    
}

extension NSObject {
    
    var ivarNameSet: Set<String> {
        guard let cls = object_getClass(self) else { return [] }
        var count: UInt32 = 0
        guard let list = class_copyIvarList(cls, &count) else { return [] }
        defer { free(list) }
        var labels = Set<String>()
        for i in 0 ..< count {
            guard let name = ivar_getName(list[Int(i)]) else { continue }
            labels.update(with: String(cString: name))
        }
        return labels
    }
}


extension String: JsonfulKeyble {
    
    private var keys: Set<String> {
        return Set([self, ".\(self)", "_\(self)"])
    }
    
    private func fetch(dic: [AnyHashable: Any]) -> Any? {
        return dic.filter({ keys.contains($0.key as? String ?? "") }).first?.value
    }
    
    private func fetch(obj: NSObject) -> Any? {
        if obj.ivarNameSet.contains(where: { keys.contains($0) }) {
            return obj.value(forKey: self)
        }
        else {
            return nil
        }
    }
    
    public func fetch(from any: Any?) -> Any? {
        
        guard let any = any else { return nil }
        
        if let dic = any as? [AnyHashable: Any], let result = fetch(dic: dic) {
            return result
        }
        else if let obj = any as? NSObject, let result = fetch(obj: obj) {
            return result
        }
        else {
            // 元组未声明key时，lable是 .0 .1 等
            
            let children = Mirror(reflecting: any).children
            
            let child = children.filter({ keys.contains($0.label ?? "") })
            
            guard let value = child.first?.value else { return nil }
            
            let mirror = Mirror(reflecting: value)
            
            if mirror.displayStyle != .optional {
                return value
            }
            
            if mirror.children.count == 0 {
                return value
            }

            return mirror.children.first?.value

        }
    }
    
    public var hashable: AnyHashable {
        return self
    }
    
    public var describe: String {
        return ".\(self)"
    }
}
