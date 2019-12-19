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
    
    func array<T: Any>(_ type: T.Type = T.self, filtration: Unwrap.Filtration = .all) -> Unwrap.Result<[T]> {
        if "\(type)".contains("Optional") {
            return self.that()
        }
        else {
            let result: Unwrap.Result<[T?]> = self.that()
            return result.map({$0.filter({filtration.validate(value: $0).data != nil})}).as().that()
        }
    }
    
    func asNSArray(filtration: Unwrap.Filtration = .all) -> Unwrap.Result<NSArray> {
        let result: Unwrap.Result<NSArray> = self.that()
        return result.as().array(Any.self).as().that()
    }

    
    func dictionary<T: Any>(_ type: T.Type = T.self, filtration: Unwrap.Filtration = .all) -> Unwrap.Result<[AnyHashable: T]> {
        if "\(type)".contains("Optional") {
            return self.that()
        }
        else {
            let result: Unwrap.Result<[AnyHashable: T?]> = self.that()
            return result.map({$0.filter({filtration.validate(value: $0).data != nil})}).as().that()
        }
    }
    
    func set<T: Hashable>(_ type: T.Type = T.self, filtration: Unwrap.Filtration = .all) -> Unwrap.Result<Set<T>> {
        if "\(type)".contains("Optional") {
            return self.that()
        }
        else {
            let result: Unwrap.Result<Set<T?>> = self.that()
            return result.map({$0.filter({filtration.validate(value: $0).data != nil})}).as().that()
        }
    }
    

    //    func asNSMutableArray(rule: Unwrap.Rule = .all) -> Unwrap.Result<NSMutableArray> {
    //        let result: Unwrap.Result<NSMutableArray> = self.as()
    //        return result.map { (array) -> NSMutableArray in
    //            array.filter(using: .init(block: { (value, _) -> Bool in
    //                return rule.isAllow(value)
    //            }))
    //            return array
    //        }.as()
    //    }
    //
    //    var asNSPointerArray: Unwrap.Result<NSPointerArray> {
    //        return self.as()
    //    }
    //
    //    func asNSDictionary(rule: Unwrap.Rule = .all) ->  Unwrap.Result<NSDictionary> {
    //        let result: Unwrap.Result<NSDictionary> = self.as()
    //        return result.asDictionary(Any.self, rule: rule).as()
    //    }
    //
    //    var asNSMutableDictionary: Unwrap.Result<NSMutableDictionary> {
    //        return self.as()
    //    }
    //
    //    var asNSMapTable: Unwrap.Result<NSMapTable<AnyObject, AnyObject>> {
    //        return self.as()
    //    }
    //
    //    var asNSSet: Unwrap.Result<NSSet> {
    //        return self.as()
    //    }
    //
    //    var asNSMutableSet: Unwrap.Result<NSMutableSet> {
    //        return self.as()
    //    }
    //
    //    var asNSHashTable: Unwrap.Result<NSHashTable<AnyObject>> {
    //        return self.as()
    //    }
    //
    
    
    
    

    
}
