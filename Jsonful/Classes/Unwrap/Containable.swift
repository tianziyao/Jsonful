//
//  Containable.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation

public protocol Containable {
    var isEmpty: Bool { get }
}

extension String: Containable {}

extension Array: Containable {}

extension Dictionary: Containable {}

extension Set: Containable {}

extension Data: Containable {}

extension Range: Containable {}

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

public extension Unwrap.As {
    
    //MARK: ---数组---

    func array<T>(_ type: T.Type = T.self, filter: Unwrap.Filter = .exception) -> Unwrap.Result<[T]> {
        // 使用T的可选类型解包，如果解包不成功，说明给定的类型不可直接转换
        let result: Unwrap.Result<[T?]> = self.that()
        // T有可能本身就是可选类型，所以可能会多次嵌套可选
        // 多次嵌套的可选如转为Any时，会被认为是Optional枚举本身，不会被判断为nil
        // 所以需要依次将数组元素进行嵌套解包
        // 解包过程中根据过滤规则去除异常元素
        // 将可选解包为非可选，如果解包不成功，说明有nil存在
        return result.map({filter.array(value: $0)}).as.that()
    }

    func nsArray(filter: Unwrap.Filter = .exception) -> Unwrap.Result<NSArray> {
        return array(Any.self, filter: filter).as.that()
    }
    
    func nsMutableArray(filtered: Unwrap.Filtered = .exception) -> Unwrap.Result<NSMutableArray> {
        return self.that().map({filtered.nsMutableArray(value: $0)})
    }

    var nsPointerArray: Unwrap.Result<NSPointerArray> {
        return self.that()
    }
    
    //MARK: ---字典---

    func dictionary<T>(_ type: T.Type = T.self, filter: Unwrap.Filter = .exception) -> Unwrap.Result<[AnyHashable: T]> {
        let result: Unwrap.Result<[AnyHashable: T?]> = self.that()
        return result.map({filter.dictionary(value: $0)}).as.that()
    }

    func nsDictionary(filter: Unwrap.Filter = .exception) ->  Unwrap.Result<NSDictionary> {
        return dictionary(Any.self, filter: filter).as.that()
    }
    
    func nsMutableDictionary(filtered: Unwrap.Filter = .exception) ->  Unwrap.Result<NSMutableDictionary> {
        return self.that().map({filtered.nsMutableDictionary(value: $0)})
    }
    
    var asNSMapTable: Unwrap.Result<NSMapTable<AnyObject, AnyObject>> {
        return self.that()
    }
    
    //MARK: ---集合---

    func set<T: Hashable>(_ type: T.Type = T.self, filtered: Unwrap.Filtered = .exception) -> Unwrap.Result<Set<T>> {
        if "\(type)".contains("Optional") {
            return self.that()
        }
        else {
            let result: Unwrap.Result<Set<T?>> = self.that()
            return self.that()
        }
    }






    //
    //    var asNSSet: Unwrap.Result<NSSet> {
    //        return self.as
    //    }
    //
    //    var asNSMutableSet: Unwrap.Result<NSMutableSet> {
    //        return self.as
    //    }
    //
    //    var asNSHashTable: Unwrap.Result<NSHashTable<AnyObject>> {
    //        return self.as
    //    }
    //
    
    
    
    

    
}

public extension Unwrap.Filter {
    
    public func array<T>(value: [T?]) -> [T?] {
        if self.contains(.none) {
            return value
        }
        else {
            return value.map({element(value: $0).data}).filter({$0 != nil})
        }
    }
    
    public func dictionary<T>(value: [AnyHashable: T?]) -> [AnyHashable: T?] {
        if self.contains(.none) {
            return value
        }
        else {
            return value.mapValues({element(value: $0).data}).filter({$0.value != nil})
        }
    }
    
    public func set<T>(value: Set<T?>) -> Set<T?> {
        if self.contains(.none) {
            return value
        }
        else {
            var data = Set(value.map({element(value: $0).data}))
            data.remove(nil)
            return value
        }
    }
    
}

public extension Unwrap.Filtered {
    
    func nsMutableArray(value: NSMutableArray) -> NSMutableArray {
        if self.contains(.none) {
            return value
        }
        else {
            value.filter(using: .init(block: { (value, _) in self.element(value: value).data != nil }))
            return value
        }
    }
    
    func nsMutableDictionary(value: NSMutableDictionary) -> NSMutableDictionary {
        if self.contains(.none) {
            return value
        }
        else {
            // 解包后删除不符合规则的数据
            value.filter({element(value: $0.value).data == nil}).forEach({value.removeObject(forKey: $0.key)})
            return value
        }
    }
    
}
