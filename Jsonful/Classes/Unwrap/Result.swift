//
//  Result.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation

public extension Unwrap {
    
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
        
        public var message: String? {
            switch self {
            case .success:
                return nil
            case .failure(let message):
                return message
            }
        }
        
        public init(value: Optional<T>, id: String, predicate: Predicate = .exception, file: String = #file, line: Int = #line) {
            let identity = Unwrap.debug { () -> String in
                let id = id.isEmpty ? "unknow" : id
                let cls = String(describing: object_getClass(value))
                return "-----\(file):\(line)-----\nid: \(id)\nrawType: <\(cls)>\n"
            }
            self = predicate.result(value: value, identity: identity)
        }
        
        internal static func failure(value: Any?, identity: String, reason: String) -> Result<T> {
            let message = Unwrap.debug { () -> String in
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
        
        public func map<O>(_ closure: (Result<T>.Success) -> Result<O>) -> Result<O> {
            switch self {
            case .failure(let message):
                return .failure(message)
            case .success(let arg):
                return closure(arg)
            }
        }
        
        public func map<O>(_ closure: (T) -> O) -> Result<O> {
            switch self {
            case .failure(let message):
                return .failure(message)
            case .success(let arg):
                return .success((closure(arg.value), arg.identity))
            }
        }

        public var `as`: As<T> {
            return As(result: self)
        }
        
        public func success(closure: (T) -> ()) {
            then(success: closure)
        }
        
        public func failure(closure: () -> ()) {
            then(success: { _ in }, failure: closure)
        }
        
        public func then(success: (T) -> (), failure: () -> () = {}) {
            switch self {
            case .success(let value, _):
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
