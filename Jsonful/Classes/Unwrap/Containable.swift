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

public extension Unwrap.As {
    
    //MARK: ---数组---
    func array<T>(_ type: T.Type = T.self, predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<[T]> {
        if let predicate = predicate {
            // 使用T的可选类型解包，如果解包不成功，说明给定的类型不可直接转换
            let result: Unwrap.Result<[T?]> = that()
            // T有可能本身就是可选类型，所以可能会多次嵌套可选
            // 多次嵌套的可选如转为Any时，会被认为是Optional枚举本身，不会被判断为nil
            // 所以需要依次将数组元素进行嵌套解包
            // 解包后根据过滤规则去除异常元素
            // 将可选解包为非可选，如果解包不成功，说明有nil存在
            return result.map({$0.map({predicate.validate(value: $0).value}).filter({$0 != nil})}).as.that()
        }
        else {
            return that()
        }
    }

    func nsArray(predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<NSArray> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSArray> = that()
            return result.map({$0.filtered(using: .init(block: { element, _ in predicate.validate(value: element).value != nil}))}).as.that()
        }
        else {
            return that()
        }
    }
    
    func nsMutableArray(predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<NSMutableArray> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSMutableArray> = that()
            return result.map({ array -> NSMutableArray in
                array.filter(using: .init(block: { element, _ in
                    return predicate.validate(value: element).value != nil
                }))
                return array
            }).as.that()
        }
        else {
            return that()
        }
    }

    var nsPointerArray: Unwrap.Result<NSPointerArray> {
        return self.that()
    }
    
    //MARK: ---字典---

    func dictionary<T>(_ type: T.Type = T.self, predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<[AnyHashable: T]> {
        if let predicate = predicate {
            let result: Unwrap.Result<[AnyHashable: T?]> = that()
            return result.map({$0.mapValues({predicate.validate(value: $0).value}).filter({$0.value != nil})}).as.that()
        }
        else {
            return that()
        }
    }

    func nsDictionary(predicate: Unwrap.Predicate? = nil) ->  Unwrap.Result<NSDictionary> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSDictionary> = that()
            return result.map({$0.filter({predicate.validate(value: $0.value).value != nil})}).as.that()
        }
        else {
            return that()
        }
    }

    func nsMutableDictionary(predicate: Unwrap.Predicate? = nil) ->  Unwrap.Result<NSMutableDictionary> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSMutableDictionary> = that()
            return result.map({ dictionary -> NSMutableDictionary in
                dictionary.filter({predicate.validate(value: $0.value).value == nil}).forEach({dictionary.removeObject(forKey: $0.key)})
                return dictionary
            }).as.that()
        }
        else {
            return that()
        }
    }

    var nsMapTable: Unwrap.Result<NSMapTable<AnyObject, AnyObject>> {
        return self.that()
    }

    //MARK: ---集合---

    func set<T: Hashable>(_ type: T.Type = T.self, predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<Set<T>> {
        if let predicate = predicate {
            let result: Unwrap.Result<Set<T?>> = self.that()
            return result.map({ (set) -> Set<T?> in
                let array = set.map({predicate.validate(value: $0).value}).filter({$0 != nil})
                return Set(array)
            }).as.that()
        }
        else {
            return that()
        }
    }

    func nsSet(predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<NSSet> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSSet> = that()
            return result.map({$0.filtered(using: .init(block: { element, _ in predicate.validate(value: element).value != nil}))}).as.that()
        }
        else {
            return that()
        }
    }

    func nsMutableSet(predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<NSMutableSet> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSMutableSet> = that()
            return result.map({ set -> NSMutableSet in
                set.filter(using: .init(block: { element, _ in
                    return predicate.validate(value: element).value != nil
                }))
                return set
            })
        }
        else {
            return that()
        }
    }

    func nsOrderSet(predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<NSOrderedSet> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSOrderedSet> = that()
            return result.map({$0.filtered(using: .init(block: {element, _ in predicate.validate(value: element).value != nil}))}).as.that()
        }
        else {
            return that()
        }
    }
    
    func nsMutableOrderedSet(predicate: Unwrap.Predicate? = nil) -> Unwrap.Result<NSMutableOrderedSet> {
        if let predicate = predicate {
            let result: Unwrap.Result<NSMutableOrderedSet> = that()
            return result.map({ set -> NSMutableOrderedSet in
                set.filter(using: .init(block: { element, _ in
                    return predicate.validate(value: element).value != nil
                }))
                return set
            })
        }
        else {
            return that()
        }
    }

    var nsHashTable: Unwrap.Result<NSHashTable<AnyObject>> {
        return self.that()
    }
}
