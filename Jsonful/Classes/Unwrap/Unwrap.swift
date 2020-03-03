//
//  Unwrap.swift
//  Demo
//
//  Created by Tian on 2019/12/3.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation

//public struct Unwrap {
//    
//    public static func lint<T>(_ value: Optional<T>, _ filter: Filter = .exception, _ id: String = "", _ file: String = #file, _ line: Int = #line) -> Result<T> {
//        let identity = Unwrap.message { () -> String in
//            let id = id.isEmpty ? "unknow" : id
//            let cls = String(describing: object_getClass(value))
//            return "-----\(file):\(line)-----\nid: \(id)\nrawType: <\(cls)>\n"
//        }
//        return filter.result(value: value, identity: identity).as.that()
//    }
//    
//    
//    internal static func message(action: () -> String) -> String {
//        #if DEBUG
//        return action()
//        #else
//        return ""
//        #endif
//    }
//}

public extension Unwraper {

//    public static func zip<O1, O2>(_ r1: Unwraper<O1>, _ r2: Unwraper<O2>) -> Unwraper<(O1, O2)> {
//
//        guard let v1 = r1.value else { return r1.map(result: .failure("")) }
//        guard let v2 = r2.value else { return r2.map(result: .failure("")) }
//        return .success((v1, v2))
//    }
    
//    public static func zip<O1, O2, O3>(_ r1: Result<O1>, _ r2: Result<O2>, _ r3: Result<O3>) -> Result<(O1, O2, O3)> {
//        guard let v1 = r1.value else { return .failure(r1.message ?? "") }
//        guard let v2 = r2.value else { return .failure(r2.message ?? "") }
//        guard let v3 = r3.value else { return .failure(r3.message ?? "") }
//        return .success(((v1, v2, v3), "", .none))
//    }
//
//    public static func zip<O1, O2, O3, O4>(_ r1: Result<O1>, _ r2: Result<O2>, _ r3: Result<O3>, _ r4: Result<O4>) -> Result<(O1, O2, O3, O4)> {
//        guard let v1 = r1.value else { return .failure(r1.message ?? "") }
//        guard let v2 = r2.value else { return .failure(r2.message ?? "") }
//        guard let v3 = r3.value else { return .failure(r3.message ?? "") }
//        guard let v4 = r4.value else { return .failure(r3.message ?? "") }
//        return .success(((v1, v2, v3, v4), "", .none))
//    }

}

public extension Unwraper {

    var string: Unwraper<String> {
        if let value = Mirror.unwrap(value: raw) {
            return .create(String(describing: value), blacklist, identify, file, line)
        }
        else {
            return .create(String(describing: raw), blacklist, identify, file, line)
        }
    }

    var number: Unwraper<NSNumber> {
        return string.map { (string) -> NSNumber? in
            let text = string.lowercased()
            let special = Set(["false", "null", "<null>", "nil", "nan", "undefined", "true"])
            guard special.contains(text) else { return NSDecimalNumber(string: text) }
            let number = NSDecimalNumber(string: text == "true" ? "1" : "0")
            return number == NSDecimalNumber.notANumber ? nil : number
        }
    }

    var int: Unwraper<Int> {
        return number.map({ $0.intValue })
    }

    var double: Unwraper<Double> {
        return number.map({ $0.doubleValue })
    }

    var bool: Unwraper<Bool> {
        return number.map({ $0.boolValue })
    }

    var array: Unwraper<[Any]> {
        return self.as.array()
    }

    var dictionary: Unwraper<[String: Any]> {
        return self.as.dictionary()
    }

}

public extension Optional {
    
    func unwraper(_ blacklist: UnwrapFilter = .exception, _ identify: String = "", _ file: String = #file, _ line: Int = #line) -> Unwraper<Wrapped> {
        return .create(self, blacklist, identify, file, line)
    }
    
}

public struct UnwrapFilter: OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let `nil`: UnwrapFilter = .init(rawValue: 1 << 1)
    public static let empty: UnwrapFilter = .init(rawValue: 1 << 2)
    public static let exception: UnwrapFilter = [.nil, .empty]
    
}

public enum UnwrapResult<T> {
    case success(T)
    case failure(String)
}

public struct UnwrapAs<T> {
    
    private let unwraper: Unwraper<T>
    
    internal init(_ unwraper: Unwraper<T>) {
        self.unwraper = unwraper
    }
    
    public func that<O>() -> Unwraper<O> {
        return unwraper.map(O.self)
    }

}

public extension UnwrapAs {
    
    //MARK: ---字符串---
    
    var string: Unwraper<String> {
        return that()
    }
    
    var nsString: Unwraper<NSString> {
        return that()
    }
    
    var nsMutableString: Unwraper<NSMutableString> {
        return that()
    }
    
    //MARK: ---属性字符串---
    
    var nsAttributedString: Unwraper<NSAttributedString> {
        return that()
    }
    
    var nsMutableAttributedString: Unwraper<NSMutableAttributedString> {
        return that()
    }
    
    //MARK: ---数字---
    
    var int: Unwraper<Int> {
        return that()
    }
    
    var double: Unwraper<Double> {
        return that()
    }
    
    var float: Unwraper<Float> {
        return that()
    }
    
    var nsNumber: Unwraper<NSNumber> {
        return that()
    }
    
    //MARK: ---布尔---
    
    var bool: Unwraper<Bool> {
        return that()
    }
    
    var objcBool: Unwraper<ObjCBool> {
        return that()
    }
    
    //MARK: ---Foundation---
    
    var data: Unwraper<Data> {
        return that()
    }
    
    var date: Unwraper<Date> {
        return that()
    }
    
    var range: Unwraper<Range<Int>> {
        return that()
    }
    
    var closedRange: Unwraper<ClosedRange<Int>> {
        return that()
    }
    
    var url: Unwraper<URL> {
        return that()
    }
    
    var urlRequest: Unwraper<URLRequest> {
        return that()
    }
    
    var nsRange: Unwraper<NSRange> {
        return that()
    }
    
    var nsData: Unwraper<NSData> {
        return that()
    }
    
    var nsMutableData: Unwraper<NSMutableData> {
        return that()
    }
    
    var nsDate: Unwraper<NSDate> {
        return that()
    }
    
    var nsURL: Unwraper<NSURL> {
        return that()
    }
    
    var nsURLRequest: Unwraper<NSURLRequest> {
        return that()
    }
    
    var nsMutableURLRequest: Unwraper<NSMutableURLRequest> {
        return that()
    }
    
    var anyObject: Unwraper<AnyObject> {
        return that()
    }
    
    var nsObject: Unwraper<NSObject> {
        return that()
    }
    
    var nsError: Unwraper<NSError> {
        return that()
    }
    
    var nsValue: Unwraper<NSValue> {
        return that()
    }
    
    
    //MARK: ---UIKit对象---
    
    var image: Unwraper<UIImage> {
        return that()
    }
    
    var color: Unwraper<UIColor> {
        return that()
    }
    
    var font: Unwraper<UIFont> {
        return that()
    }
    
    //MARK: ---CoreGraphics对象---
    
    var cgFloat: Unwraper<CGFloat> {
        return that()
    }
    
    var cgSize: Unwraper<CGSize> {
        return that()
    }
    
    var cgPoint: Unwraper<CGPoint> {
        return that()
    }
    
    var cgRect: Unwraper<CGRect> {
        return that()
    }
    
    var cgColor: Unwraper<CGColor> {
        return that()
    }
    
    
    //MARK: ---数组---
    func array<T>(_ type: T.Type = T.self) -> Unwraper<[T]> {
        return self.that()
    }
    
    func array() -> Unwraper<[Any]> {
        return self.that()
    }
    
    func nsArray() -> Unwraper<NSArray> {
        return self.that()
    }
    
    func nsMutableArray() -> Unwraper<NSMutableArray> {
        return self.that()
    }
    
    var nsPointerArray: Unwraper<NSPointerArray> {
        return self.that()
    }
    
    //MARK: ---字典---
    
    func dictionary<Key: Hashable, Value>(_ key: Key.Type = Key.self, _ value: Value.Type = Value.self) -> Unwraper<[Key: Value]> {
        return self.that()
    }
    
    func dictionary<Value>(_ value: Value.Type = Value.self) -> Unwraper<[AnyHashable: Value]> {
        return self.that()
    }
    
    func dictionary() -> Unwraper<[String: Any]> {
        return self.that()
    }
    
    func nsDictionary() ->  Unwraper<NSDictionary> {
        return self.that()

    }
    
    func nsMutableDictionary() ->  Unwraper<NSMutableDictionary> {
        return self.that()
    }
    
    var nsMapTable: Unwraper<NSMapTable<AnyObject, AnyObject>> {
        return self.that()
    }
    
    //MARK: ---集合---
    
    func set<T: Hashable>(_ type: T.Type = T.self) -> Unwraper<Set<T>> {
        return self.that()
    }
    
    func nsSet() -> Unwraper<NSSet> {
        return self.that()
    }
    
    func nsMutableSet() -> Unwraper<NSMutableSet> {
        return self.that()
    }
    
    func nsOrderSet() -> Unwraper<NSOrderedSet> {
        return self.that()
    }
    
    func nsMutableOrderedSet() -> Unwraper<NSMutableOrderedSet> {
        return self.that()
    }
    
    var nsHashTable: Unwraper<NSHashTable<AnyObject>> {
        return self.that()
    }
}

public struct Unwraper<T> {
        
    internal var identify: String = ""
    
    internal var file: String = ""
    
    internal var line: Int = 0
    
    internal var blacklist: UnwrapFilter = .exception
    
    internal var result: UnwrapResult<T> = .failure("")
    
    internal var raw: Any?
    
    internal init(raw: Any?, blacklist: UnwrapFilter) {
        self.raw = raw
        self.blacklist = blacklist
    }
    
    internal mutating func validate() {
        // 预防可选嵌套产生的非空判断错误
        let data = Mirror.unwrap(value: raw)
                
        if data == nil && blacklist.contains(.nil) {
            let text = describing("data is nil.")
            self.result = .failure(text)
        }
        else if data is NSNull && blacklist.contains(.nil) {
            let text = describing("data is null.")
            self.result = .failure(text)
        }
        else if let data = data as? Containable, blacklist.contains(.empty), data.isEmpty {
            let text = describing("data is empty.")
            self.result = .failure(text)
        }
        else if let data = data as? T {
            self.result = .success(data)
        }
        else {
            let text = describing("data is not \(T.self).")
            self.result = .failure(text)
        }
    }
    
    internal func describing(_ describing: String) -> String {
        let text = """
        ---------------\(file):\(line)---------------
        identify: \(identify)
        rawType: <\(String(describing: object_getClass(raw)))>
        rawValue: \(String(describing: raw))
        describing: \(describing)
        ---------------------END---------------------
        """
        return text
    }
    
    public static func create(_ value: Any?, _ blacklist: UnwrapFilter = .exception, _ identify: String = "unknow", _ file: String = #file, _ line: Int = #line) -> Unwraper<T> {
        var unwraper = Unwraper(raw: value, blacklist: blacklist)
        unwraper.identify = identify
        unwraper.file = file
        unwraper.line = line
        unwraper.validate()
        return unwraper
    }
    
    internal func map<O>(result: UnwrapResult<O>) -> Unwraper<O> {
        var unwraper = Unwraper<O>(raw: raw, blacklist: blacklist)
        unwraper.identify = identify
        unwraper.file = file
        unwraper.line = line
        unwraper.result = result
        return unwraper
    }
    
    public func map<O>(_ closure: (T) -> UnwrapResult<O>) -> Unwraper<O> {
        switch self.result {
        case .success(let value):
            return map(result: closure(value))
        case .failure(let message):
            return map(result: .failure(message))
        }
    }
    
    public func map<O>(_ closure: (T) -> O?) -> Unwraper<O> {
        return map({ (value) -> UnwrapResult<O> in
            if let value = closure(value) {
                return .success(value)
            }
            else {
                let text = describing("data is not <\(O.self)>.")
                return .failure(text)
            }
        })
    }
    
    public func map<O>(_ type: O.Type) -> Unwraper<O> {
        return map({ $0 as? O })
    }
    
    public var `as`: UnwrapAs<T> {
        return UnwrapAs(self)
    }
    
    public func result(success: (T) -> (), failure: (Any?) -> ()) {
        switch self.result {
        case .success(let value):
            success(value)
        case .failure(let message):
            #if DEBUG
            dump(message)
            #endif
            failure(raw)
        }
    }
    
    public func success(_ closure: (T) -> ()) {
        result(success: closure, failure: { _ in })
    }
    
    public func failure(_ closure: (Any?) -> ()) {
        result(success: { _ in }, failure: closure)
    }
    
    public var value: T? {
        switch self.result {
        case .success(let value):
            return value
        case .failure(_):
            return nil
        }
    }
}
