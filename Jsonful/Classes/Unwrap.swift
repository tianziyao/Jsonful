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
        
        public func map<O>(closure: (Result<T>.Success) -> Result<O>) -> Result<O> {
            switch self {
            case .failure(let reason):
                return .failure(reason)
            case .success(let arg):
                return closure(arg)
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
    
    var image: Unwrap.Result<UIImage> {
        return self.this()
    }
    
    var color: Unwrap.Result<UIColor> {
        return self.this()
    }
    
    var font: Unwrap.Result<UIFont> {
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

extension URL: Containable {
    public var isEmpty: Bool {
        return absoluteString.isEmpty
    }
}

public extension Unwrap.Result {

    var string: Unwrap.Result<String> {
        return self.this()
    }

    var int: Unwrap.Result<Int> {
        return self.this()
    }

    var double: Unwrap.Result<Double> {
        return self.this()
    }

    var bool: Unwrap.Result<Bool> {
        return self.this()
    }

    var error: Unwrap.Result<Error> {
        return self.this()
    }
    
    func array<T: Any>() -> Unwrap.Result<[T]> {
        return array(T.self)
    }
    
    func array<T: Any>(_ t: T.Type) -> Unwrap.Result<[T]> {
        return self.this()
    }
    
    func array() -> Unwrap.Result<[Any]> {
        return array(Any.self)
    }
    
    func dictionary<T: Any>(_ t: T.Type) -> Unwrap.Result<[AnyHashable: T]> {
        return self.this()
    }
    
    func dictionary<T: Any>() -> Unwrap.Result<[AnyHashable: T]> {
        return self.dictionary(T.self)
    }
    
    func dictionary() -> Unwrap.Result<[AnyHashable: Any]> {
        return dictionary(Any.self)
    }
    
    func set<T: Hashable>(_ t: T.Type) -> Unwrap.Result<Set<T>> {
        return self.this()
    }

    func set<T: Hashable>() -> Unwrap.Result<Set<T>> {
        return self.set(T.self)
    }
    
    func set() -> Unwrap.Result<Set<AnyHashable>> {
        return self.set(AnyHashable.self)
    }

    var date: Unwrap.Result<Date> {
        return self.this()
    }
    
    var data: Unwrap.Result<Data> {
        return self.this()
    }
    
    var range: Unwrap.Result<Range<Int>> {
        return self.this()
    }
    
    var url: Unwrap.Result<URL> {
        return self.this()
    }
    
}


public extension Unwrap.Result {

    var cgFloat: Unwrap.Result<CGFloat> {
        return self.this()
    }
    
    var cgSize: Unwrap.Result<CGSize> {
        return self.this()
    }
    
    var cgPoint: Unwrap.Result<CGPoint> {
        return self.this()
    }
    
    var cgRect: Unwrap.Result<CGRect> {
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
    
    var nsString: Unwrap.Result<NSString> {
        return self.this()
    }
    
    var nsMutableString: Unwrap.Result<NSMutableString> {
        return self.this()
    }
    
    var nsAttributedString: Unwrap.Result<NSAttributedString> {
        return self.this()
    }
    
    var nsMutableAttributedString: Unwrap.Result<NSMutableAttributedString> {
        return self.this()
    }
    
    var nsNumber: Unwrap.Result<NSNumber> {
        return self.this()
    }
    
    var nsArray: Unwrap.Result<NSArray> {
        return self.this()
    }
    
    var nsMutableArray: Unwrap.Result<NSMutableArray> {
        return self.this()
    }
    
    var nsDictionary: Unwrap.Result<NSDictionary> {
        return self.this()
    }
    
    var nsMutableDictionary: Unwrap.Result<NSMutableDictionary> {
        return self.this()
    }
    
    var nsSet: Unwrap.Result<NSSet> {
        return self.this()
    }
    
    var nsMutableSet: Unwrap.Result<NSMutableSet> {
        return self.this()
    }
    
    var nsDate: Unwrap.Result<NSDate> {
        return self.this()
    }
    
    var nsData: Unwrap.Result<NSData> {
        return self.this()
    }
    
    var nsRange: Unwrap.Result<NSRange> {
        return self.this()
    }
    
    var nsObject: Unwrap.Result<NSObject> {
        return self.this()
    }
    
    var nsUrl: Unwrap.Result<NSURL> {
        return self.this()
    }
    
    var nsBool: Unwrap.Result<ObjCBool> {
        return self.this()
    }
    
    var nsError: Unwrap.Result<NSError> {
        return self.this()
    }
    
    var nsValue: Unwrap.Result<NSValue> {
        return self.this()
    }

}

public extension Optional {

    func unwrap(file: String = #file, line: Int = #line, id: String = "") -> Unwrap.Result<Wrapped> {
        return .init(value: self, file: file, line: line, id: id)
    }
}
