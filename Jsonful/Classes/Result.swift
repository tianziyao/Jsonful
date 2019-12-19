//
//  Result.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation

extension Unwrap {
    
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
        
        public var info: String? {
            switch self {
            case .success:
                return nil
            case .failure(let info):
                return info
            }
        }
        
        public init(value: Optional<T>, id: String, rule: Filtration = .all, file: String = #file, line: Int = #line) {
            let identity = Unwrap.debug { () -> String in
                let cls = String(describing: object_getClass(value))
                return "-----\(file):\(line)-----\nid: \(id)\nrawType: <\(cls)>\n"
            }
            self = rule.result(value: value, identity: identity)
        }
        
        internal static func failure(value: Any?, identity: String, reason: String) -> Result<T> {
            let info = Unwrap.debug { () -> String in
                var string: String = ""
                string.append(contentsOf: identity)
                if let value = value {
                    string.append(contentsOf: "rawValue: \(String(describing: value))\n")
                }
                string.append(contentsOf: "reason: \(reason).\n")
                return string
            }
            return .failure(info)
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
        
        public func `as`() -> As<T> {
            return As(result: self)
        }
        
        //        public func `as`<O>(closure: (Result<O>.Success) -> Result<O> = {.success($0)}) -> Result<O> {
        //            return map { (arg) -> Unwrap.Result<O> in
        //                if let data = arg.value as? O {
        //                    return closure((data, arg.identity))
        //                }
        //                else {
        //                    return .failure(identity: arg.identity, value: arg.value, reason: "this data is not <\(O.self)>")
        //                }
        //            }
        //        }
        //
        //        public func `as`<O: Containable>() -> Result<O> {
        //            return `as`(closure: { (arg) -> Result<O> in
        //                if arg.value.isEmpty {
        //                    return .failure(identity: arg.identity, value: nil, reason: "this data is empty")
        //                }
        //                else {
        //                    return .success(arg)
        //                }
        //            })
        //        }
        
        public func then(success: (T) -> (), failure: ((String) -> ())? = nil) {
            switch self {
            case .success(let value, _):
                success(value)
            case .failure(let reason):
                #if DEBUG
                dump(reason)
                #endif
                failure?(reason)
            }
        }
        
    }
    
}
