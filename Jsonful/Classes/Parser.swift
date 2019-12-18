//
//  Parser.swift
//  Demo
//
//  Created by Tian on 2019/12/13.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

extension Mirror {
    
    func object(value: Any, depth: Int) -> [String: Any?] {
        var dictionary = [String: Any?]()
        for child in self.children {
            dictionary[child.label ?? ""] = Mirror.parse(value: child.value, depth: depth)
        }
        return dictionary
    }
    
    func array(depth: Int) -> [Any?] {
        var array = [Any?]()
        for child in self.children {
            array.append(Mirror.parse(value: child.value, depth: depth))
        }
        return array
    }
    
    func dictionary(depth: Int) -> [AnyHashable: Any?] {
        var dictionary = [AnyHashable: Any]()
        for child in self.children {
            let children = Mirror(reflecting: child.value).children.map({$0})
            if let key = children.first?.value as? AnyHashable {
                dictionary[key] = children.last?.value
            }
        }
        return dictionary
    }
    
    func enmu(value: Any, depth: Int) -> Any {
        return object(value: value, depth: depth)
    }
    
    func set(value: Any, depth: Int) -> Set<AnyHashable?> {
        var set = Set<AnyHashable?>()
        for child in self.children {
            set.update(with: Mirror.parse(value: child.value, depth: depth) as? AnyHashable)
        }
        return set
    }
    
    public static func parse(value: Any?, depth: Int = 1000) -> Any? {
        guard let value = value, depth >= 0 else {
            return nil
        }
        let mirror = Mirror(reflecting: value)
        switch mirror.displayStyle {
        case .none:
            // 基本类型
            return value
        case .some(let style):
            // 没有子节点的数据 不需要解析
            guard mirror.children.count != 0 else { return value }
            switch style {
            case .set:
                return mirror.set(value: value, depth: depth - 1)
            case .collection:
                return mirror.array(depth: depth - 1)
            case .dictionary:
                return mirror.dictionary(depth: depth - 1)
            case .enum:
                return mirror.enmu(value: value, depth: depth - 1)
            case .struct, .class, .tuple:
                return mirror.object(value: value, depth: depth - 1)
            case .optional:
                // 尝试解析.some，如获取不到则是nil
                if let value = mirror.children.first?.value {
                    return parse(value: value, depth: depth)
                }
                else {
                    return nil
                }
            }
        }
    }
    
    public static func unwrap(value: Any?) -> Any? {
        guard let value = value else { return nil }
        let mirror = Mirror(reflecting: value)
        guard mirror.displayStyle == .optional else { return value }
        if let value = mirror.children.first?.value {
            return unwrap(value: value)
        }
        else {
            return nil
        }
    }
}
