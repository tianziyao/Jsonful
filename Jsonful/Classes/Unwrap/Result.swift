//
//  Result.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation

public extension Unwrap {
    
    public enum Result<T> {
        
        public typealias Success = (value: T, identity: String, filter: Filter)
        
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
        
        public var message: String? {
            switch self {
            case .success:
                return nil
            case .failure(let message):
                return message
            }
        }
        
        public static func failure(value: Any?, identity: String, reason: String) -> Result<T> {
            let message = Unwrap.message { () -> String in
                var string: String = ""
                string.append(contentsOf: identity)
                if let value = value {
                    string.append(contentsOf: "rawValue: \(String(describing: value))\n")
                }
                string.append(contentsOf: "reason: \(reason).\n")
                return string
            }
            return .failure(message)
        }
        
        public func map<O>(_ closure: (T) -> O?) -> Result<O> {
            switch self {
            case .failure(let message):
                return .failure(message)
            case .success(let arg):
                if let value = closure(arg.value) {
                    return arg.filter.result(value: value, identity: arg.identity)
                }
                else {
                    return .failure(value: arg.value, identity: arg.identity, reason: "this data is not \(O.self)")
                }
            }
        }
        
        public func map<O>(_ type: O.Type) -> Result<O> {
            return map({ $0 as? O })
        }
        
        public var `as`: As<T> {
            return As(result: self)
        }
        
        public func success(_ closure: (T) -> ()) {
            then(success: closure)
        }
        
        public func failure(_ closure: () -> ()) {
            then(success: { _ in }, failure: closure)
        }
        
        public func then(success: (T) -> (), failure: () -> () = {}) {
            switch self {
            case .success(let value, _, _):
                return success(value)
            case .failure(let message):
                #if DEBUG
                dump(message)
                #endif
                return failure()
            }
        }
    }
    
}
