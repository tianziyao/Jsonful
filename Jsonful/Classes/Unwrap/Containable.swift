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

extension ClosedRange: Containable {}

extension NSString: Containable {
    public var isEmpty: Bool {
        return length == 0
    }
}

extension NSAttributedString: Containable {
    public var isEmpty: Bool {
        return length == 0
    }
}

extension NSArray: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSPointerArray: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSDictionary: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

@objc extension NSMapTable: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSSet: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSOrderedSet: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

@objc extension NSHashTable: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSData: Containable {
    public var isEmpty: Bool {
        return length == 0
    }
}

extension NSRange: Containable {
    public var isEmpty: Bool {
        return length <= 0
    }
}

internal extension Unwrap.Filter {
    
    func result<T, O>(value: Unwrap.As<T>, closure: (Unwrap.As<T>) -> Unwrap.Result<O>) -> Unwrap.Result<O> {
        if self.contains(.none) {
            return value.that()
        }
        else {
            return closure(value)
        }
    }
}

public extension Unwrap.As {
    
    //MARK: ---数组---
    func array<T>(_ type: T.Type = T.self, filter: Unwrap.Filter = .none) -> Unwrap.Result<[T]> {
        return filter.result(value: self, closure: { value in
            // 使用T的可选类型解包，如果解包不成功，说明给定的类型不可直接转换
            let result: Unwrap.Result<[T?]> = that()
            // T有可能本身就是可选类型，所以可能会多次嵌套可选
            // 多次嵌套的可选如转为Any时，会被认为是Optional枚举本身，不会被判断为nil
            // 所以需要依次将数组元素进行嵌套解包
            // 解包后根据过滤规则去除异常元素
            // 将可选解包为非可选，如果解包不成功，说明有nil存在
            return result.map({$0.map({Mirror.unwrap(value: $0)}).filter({filter.validate(value: $0).result})}).as.that()
        })
    }
    
    func array(filter: Unwrap.Filter = .none) -> Unwrap.Result<[Any]> {
        return array(Any.self, filter: filter)
    }
    
    func nsArray(filter: Unwrap.Filter = .none) -> Unwrap.Result<NSArray> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<NSArray> = that()
            return result.map({$0.filtered(using: .init(block: { element, _ in filter.validate(value: element).result}))}).as.that()
        })
    }
    
    func nsMutableArray(filter: Unwrap.Filter = .none) -> Unwrap.Result<NSMutableArray> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<NSMutableArray> = that()
            return result.map({ array -> NSMutableArray in
                array.filter(using: .init(block: { element, _ in filter.validate(value: element).result }))
                return array
            })
        })
    }

    var nsPointerArray: Unwrap.Result<NSPointerArray> {
        return self.that()
    }
    
    //MARK: ---字典---

    func dictionary<Key: Hashable, Value>(_ key: Key.Type = Key.self, _ value: Value.Type = Value.self, filter: Unwrap.Filter = .none) -> Unwrap.Result<[Key: Value]> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<[Key: Value?]> = that()
            return result.map({$0.mapValues({Mirror.unwrap(value: $0)}).filter({filter.validate(value: $0.value).result})}).as.that()
        })
    }
    
    func dictionary<Value>(_ value: Value.Type = Value.self, filter: Unwrap.Filter = .none) -> Unwrap.Result<[AnyHashable: Value]> {
        return dictionary(AnyHashable.self, value, filter: filter)
    }
    
    func dictionary(filter: Unwrap.Filter = .none) -> Unwrap.Result<[String: Any]> {
        return dictionary(String.self, Any.self, filter: filter)
    }

    func nsDictionary(filter: Unwrap.Filter = .none) ->  Unwrap.Result<NSDictionary> {
        return filter.result(value: self, closure: { value in
            return dictionary(AnyHashable.self, Any.self, filter: filter).as.that()
        })
    }

    func nsMutableDictionary(filter: Unwrap.Filter = .none) ->  Unwrap.Result<NSMutableDictionary> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<NSMutableDictionary> = that()
            return result.map({ dictionary -> NSMutableDictionary in
                dictionary.filter({filter.validate(value: $0.value).result}).forEach({dictionary.removeObject(forKey: $0.key)})
                return dictionary
            })
        })
    }

    var nsMapTable: Unwrap.Result<NSMapTable<AnyObject, AnyObject>> {
        return self.that()
    }

    //MARK: ---集合---

    func set<T: Hashable>(_ type: T.Type = T.self, filter: Unwrap.Filter = .none) -> Unwrap.Result<Set<T>> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<Set<T?>> = that()
            return result.map({ (set) -> Set<T?>? in
                let array = set.map({Mirror.unwrap(value: $0) as? T}).filter({filter.validate(value: $0).result})
                return Set(array)
            }).as.that()
        })
    }

    func nsSet(filter: Unwrap.Filter = .none) -> Unwrap.Result<NSSet> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<NSSet> = that()
            return result.map({$0.filtered(using: .init(block: { element, _ in filter.validate(value: element).result }))}).as.that()
        })
    }

    func nsMutableSet(filter: Unwrap.Filter = .none) -> Unwrap.Result<NSMutableSet> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<NSMutableSet> = that()
            return result.map({ set -> NSMutableSet in
                set.filter(using: .init(block: { element, _ in filter.validate(value: element).result }))
                return set
            })
        })
    }

    func nsOrderSet(filter: Unwrap.Filter = .none) -> Unwrap.Result<NSOrderedSet> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<NSOrderedSet> = that()
            return result.map({$0.filtered(using: .init(block: {element, _ in filter.validate(value: element).result }))})
        })
    }
    
    func nsMutableOrderedSet(filter: Unwrap.Filter = .none) -> Unwrap.Result<NSMutableOrderedSet> {
        return filter.result(value: self, closure: { value in
            let result: Unwrap.Result<NSMutableOrderedSet> = that()
            return result.map({ set -> NSMutableOrderedSet in
                set.filter(using: .init(block: { element, _ in filter.validate(value: element).result }))
                return set
            })
        })
    }

    var nsHashTable: Unwrap.Result<NSHashTable<AnyObject>> {
        return self.that()
    }
}
