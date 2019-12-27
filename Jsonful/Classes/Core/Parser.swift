//
//  Parser.swift
//  Demo
//
//  Created by Tian on 2019/12/13.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

extension Mirror {
    
    public static var ignore = Set<String>(["NS", "UI", "CG", "CF", "CA", "CV", "CT", "JS"])
    
    func ignore(value: Any, ignore: Set<String>, depth: Int) -> Any {
        let cls = String(cString: class_getName(object_getClass(value)))
        let prefix = (cls.replacingOccurrences(of: "_", with: "") as NSString).substring(to: 2)
        // 过滤标准库对象
        if ignore.contains(prefix) {
            return mutableErased(value: value)
        }
        else {
            return object(value: value, ignore: ignore, depth: depth)
        }
    }
    
    func object(value: Any, ignore: Set<String>, depth: Int) -> [String: Any?] {
        var dictionary = [String: Any?]()
        for child in self.children {
            dictionary[child.label ?? ""] = Mirror.parse(value: child.value, ignore: ignore, depth: depth)
        }
        return dictionary
    }
    
    func array(value: Any, ignore: Set<String>, depth: Int) -> [Any?] {
        var array = [Any?]()
        for child in self.children {
            array.append(Mirror.parse(value: child.value, ignore: ignore, depth: depth))
        }
        return array
    }
    
    func dictionary(value: Any, ignore: Set<String>, depth: Int) -> [AnyHashable: Any?] {
        var dictionary = [AnyHashable: Any]()
        for child in self.children {
            let children = Mirror(reflecting: child.value).children.map({$0})
            if let key = children.first?.value as? AnyHashable {
                dictionary[key] = children.last?.value
            }
        }
        return dictionary
    }
    
    func set(value: Any, ignore: Set<String>, depth: Int) -> Set<AnyHashable?> {
        var set = Set<AnyHashable?>()
        for child in self.children {
            set.update(with: Mirror.parse(value: child.value, ignore: ignore, depth: depth) as? AnyHashable)
        }
        return set
    }
    
    func `enum`(value: Any, ignore: Set<String>, depth: Int) -> Any {
        if children.count == 0 {
            return value
        }
        else {
            return object(value: value, ignore: ignore, depth: depth)
        }
    }
    
    // 擦除可变类型，snapshot 不可以修改之前的实例
    func mutableErased(value: Any) -> Any {
//        guard let obj = value as? NSObject else { return value }
//        guard let cls = object_getClass(obj) else { return value }
//        guard "\(cls)".contains("Mutable") else { return value }
//        return obj.mutableCopy()
        switch value {
        case let data as NSMutableString:
            return data.mutableCopy()
        case let data as NSMutableAttributedString:
            return data.mutableCopy()
        case let data as NSMutableData:
            return data.mutableCopy()
        case let data as NSMutableURLRequest:
            return data.mutableCopy()
        default:
            return value
        }
    }
    
    public static func parse(value: Any?, ignore: Set<String> = ignore, depth: Int = 1000) -> Any? {
        guard let value = value, depth >= 0 else {
            return nil
        }
        let mirror = Mirror(reflecting: value)
        switch mirror.displayStyle {
        case .none:
            // 基本类型
            return value
        case .some(let style):
            switch style {
            case .set:
                return mirror.set(value: value, ignore: ignore, depth: depth - 1)
            case .collection:
                return mirror.array(value: value, ignore: ignore, depth: depth - 1)
            case .dictionary:
                return mirror.dictionary(value: value, ignore: ignore, depth: depth - 1)
            case .enum:
                return mirror.enum(value: value, ignore: ignore, depth: depth - 1)
            case .tuple:
                return mirror.object(value: value, ignore: ignore, depth: depth - 1)
            case .struct, .class:
                return mirror.ignore(value: value, ignore: ignore, depth: depth - 1)
            case .optional:
                // 尝试解析.some，如获取不到则是nil
                if let value = mirror.children.first?.value {
                    return parse(value: value, ignore: ignore, depth: depth)
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
        switch mirror.children.first?.value {
        case .none:
            return .none
        case .some(let value):
            return unwrap(value: value)
        }
    }
}
