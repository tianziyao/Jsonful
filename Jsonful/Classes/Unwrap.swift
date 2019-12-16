//
//  Unwrap.swift
//  Demo
//
//  Created by Tian on 2019/12/3.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

public struct Unwrap {
    
    public enum Result<T> {
        
        public typealias Success = (value: T, identity: String)
        
        case success(Success)
        case failure(String)
        
        public var value: T? {
            switch self {
            case .success(let arg):
                return arg.value
            case .failure:
                return nil
            }
        }
        
        public var reason: String? {
            switch self {
            case .success:
                return nil
            case .failure(let text):
                return text
            }
        }
        
        public init(value: Optional<T>, file: String = #file, line: Int = #line, id: String) {
            let identity = "-----\(file):\(line)-----\nid = \(id), rawType = <\(T.self)>\n"
            switch value {
            case .none:
                self = .failure("\(identity)reason: this data is nil.\n")
            case .some(let value):
                self = .success((value, identity))
            }
        }
        
        public func map<O>(_ closure: (Result<T>.Success) -> Result<O>) -> Result<O> {
            switch self {
            case .failure(let reason):
                return .failure(reason)
            case .success(let arg):
                return closure(arg)
            }
        }
        
        public func map<O>(_ closure: (T) -> O) -> Result<O> {
            switch self {
            case .failure(let reason):
                return .failure(reason)
            case .success(let arg):
                return .success((closure(arg.value), arg.identity))
            }
        }
             
        public func this<O>(closure: (Result<O>.Success) -> Result<O> = {.success($0)}) -> Result<O> {
            return map { (arg) -> Unwrap.Result<O> in
                if let data = arg.value as? O {
                    return closure((data, arg.identity))
                }
                else {
                    let cls = String(describing: object_getClass(arg.value))
                    let reason = "\(arg.identity)reason: <\(cls)> -> <\(O.self)> fail\nraw: \(arg.value)\n"
                    return .failure(reason)
                }
            }
        }
        
        public func this<O: Containable>() -> Result<O> {
            return this(closure: { (arg) -> Result<O> in
                if arg.value.isEmpty {
                    return .failure("\(arg.identity)reason: this data is empty.\n")
                }
                else {
                    return .success(arg)
                }
            })
        }
        
        public func then(success: (T) -> (), failure: ((String) -> ())? = nil) {
            switch self {
            case .success(let value, _):
                success(value)
            case .failure(let reason):
                #if DEBUG
                print(reason)
                #endif
                failure?(reason)
            }
        }

    }
    
    public static func merge<O1, O2>(_ r1: Result<O1>, _ r2: Result<O2>) -> Result<(O1, O2)> {
        guard let v1 = r1.value else { return .failure(r1.reason ?? "") }
        guard let v2 = r2.value else { return .failure(r2.reason ?? "") }
        return .success(((v1, v2), ""))
    }
    
    public static func merge<O1, O2, O3>(_ r1: Result<O1>, _ r2: Result<O2>, _ r3: Result<O3>) -> Result<(O1, O2, O3)> {
        guard let v1 = r1.value else { return .failure(r1.reason ?? "") }
        guard let v2 = r2.value else { return .failure(r2.reason ?? "") }
        guard let v3 = r3.value else { return .failure(r3.reason ?? "") }
        return .success(((v1, v2, v3), ""))
    }
}

public extension Unwrap.Result {
    
    var asImage: Unwrap.Result<UIImage> {
        return self.this()
    }
    
    var asColor: Unwrap.Result<UIColor> {
        return self.this()
    }
    
    var asFont: Unwrap.Result<UIFont> {
        return self.this()
    }
    
}

public protocol Containable {
    var isEmpty: Bool { get }
}

extension String: Containable {}

extension Array: Containable {}

extension Dictionary: Containable {}

extension Set: Containable {}

extension Data: Containable {}

extension Range: Containable {}

//public extension Unwrap.Result {
//
//    var asString: Unwrap.Result<String> {
//        return self.map({ (value) -> String in
//            return String(describing: value)
//        })
//    }
//
//    var asInt: Unwrap.Result<Int> {
//        return self.asString.map({ (arg) -> Unwrap.Result<Int> in
//            if let int = Int(arg.value) {
//                return .success((int, arg.identity))
//            }
//            else {
//                return .failure(arg.identity)
//            }
//        })
//    }
//}

public extension Unwrap.Result {

    var asString: Unwrap.Result<String> {
        return self.this()
    }

    var asInt: Unwrap.Result<Int> {
        return self.this()
    }

    var asDouble: Unwrap.Result<Double> {
        return self.this()
    }

    var asBool: Unwrap.Result<Bool> {
        return self.this()
    }

    var asError: Unwrap.Result<Error> {
        return self.this()
    }
    
    func asArray<T: Any>(_ type: T.Type) -> Unwrap.Result<[T?]> {
        return self.this()
    }
    
    func asArray<T: Any>() -> Unwrap.Result<[T?]> {
        return self.asArray(T.self)
    }

    func asArray() -> Unwrap.Result<[Any?]> {
        return self.asArray(Any.self)
    }

    func asDictionary<T: Any>(_ t: T.Type) -> Unwrap.Result<[AnyHashable: T?]> {
        return self.this()
    }
    
    func asDictionary<T: Any>() -> Unwrap.Result<[AnyHashable: T?]> {
        return self.asDictionary(T.self)
    }
    
    func asDictionary() -> Unwrap.Result<[AnyHashable: Any?]> {
        return self.asDictionary(Any.self)
    }
    
    func asSet<T: Hashable>(_ t: T.Type) -> Unwrap.Result<Set<T?>> {
        return self.this()
    }

    func asSet<T: Hashable>() -> Unwrap.Result<Set<T?>> {
        return self.asSet(T.self)
    }
    
    func asSet() -> Unwrap.Result<Set<AnyHashable?>> {
        return self.asSet(AnyHashable.self)
    }

    var asDate: Unwrap.Result<Date> {
        return self.this()
    }
    
    var asData: Unwrap.Result<Data> {
        return self.this()
    }
    
    var asRange: Unwrap.Result<Range<Int>> {
        return self.this()
    }
    
}


public extension Unwrap.Result {

    var asCGFloat: Unwrap.Result<CGFloat> {
        return self.this()
    }
    
    var asCGSize: Unwrap.Result<CGSize> {
        return self.this()
    }
    
    var asCGPoint: Unwrap.Result<CGPoint> {
        return self.this()
    }
    
    var asCGRect: Unwrap.Result<CGRect> {
        return self.this()
    }
    
}

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
        return length == 0
    }
}

extension NSURL: Containable {
    public var isEmpty: Bool {
        return (absoluteString ?? "").count == 0
    }
}

public extension Unwrap.Result {
    
    var asNSString: Unwrap.Result<NSString> {
        return self.this()
    }
    
    var asNSMutableString: Unwrap.Result<NSMutableString> {
        return self.this()
    }
    
    var asNSAttributedString: Unwrap.Result<NSAttributedString> {
        return self.this()
    }
    
    var asNSMutableAttributedString: Unwrap.Result<NSMutableAttributedString> {
        return self.this()
    }
    
    var asNSNumber: Unwrap.Result<NSNumber> {
        return self.this()
    }
    
    var asNSArray: Unwrap.Result<NSArray> {
        return self.this()
    }
    
    var asNSMutableArray: Unwrap.Result<NSMutableArray> {
        return self.this()
    }
    
    var asNSPointerArray: Unwrap.Result<NSPointerArray> {
        return self.this()
    }
    
    var asNSDictionary: Unwrap.Result<NSDictionary> {
        return self.this()
    }
    
    var asNSMutableDictionary: Unwrap.Result<NSMutableDictionary> {
        return self.this()
    }
    
    var asNSMapTable: Unwrap.Result<NSMapTable<AnyObject, AnyObject>> {
        return self.this()
    }
    
    var asNSSet: Unwrap.Result<NSSet> {
        return self.this()
    }
    
    var asNSMutableSet: Unwrap.Result<NSMutableSet> {
        return self.this()
    }
    
    var asNSHashTable: Unwrap.Result<NSHashTable<AnyObject>> {
        return self.this()
    }
    
    var asNSDate: Unwrap.Result<NSDate> {
        return self.this()
    }
    
    var asNSData: Unwrap.Result<NSData> {
        return self.this()
    }
    
    var asNSRange: Unwrap.Result<NSRange> {
        return self.this()
    }
    
    var asNSObject: Unwrap.Result<NSObject> {
        return self.this()
    }
    
    var asNSUrl: Unwrap.Result<NSURL> {
        return self.this()
    }
    
    var asNSBool: Unwrap.Result<ObjCBool> {
        return self.this()
    }
    
    var asNSError: Unwrap.Result<NSError> {
        return self.this()
    }
    
    var asNSValue: Unwrap.Result<NSValue> {
        return self.this()
    }

}

public extension Optional {

    func unwrap(file: String = #file, line: Int = #line, id: String = "") -> Unwrap.Result<Wrapped> {
        return .init(value: self, file: file, line: line, id: id)
    }
}
