//
//  Rule.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation


public extension Unwrap {
        
    public struct Filter: OptionSet {
        
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let `nil`: Filter = .init(rawValue: 1 << 1)
        public static let empty: Filter = .init(rawValue: 1 << 2)
        public static let none: Filter = .init(rawValue: 1 << 3)
        public static let exception: Filter = [.nil, .empty]

        public func result<T>(value: T, identity: String) -> Result<T> {
            let validate = self.validate(value: value)
            guard validate.result == true else {
                return .failure(value: validate.value, identity: identity, reason: validate.reason)
            }
            guard let data = validate.value as? T else {
                return .failure(value: validate.value, identity: identity, reason: "this data is not \(T.self)")
            }
            return .success((data, identity, self))
        }
                
        public func validate(value: Any?) -> (result: Bool, reason: String, value: Any?) {
            let value = Mirror.unwrap(value: value)
            if self.contains(.none) {
                return (true, "success", value)
            }
            if value == nil && self.contains(.nil) {
                return (false, "this data is nil", value)
            }
            if value is NSNull && self.contains(.nil) {
                return (false, "this data is null", value)
            }
            if let data = value as? Containable, self.contains(.empty), data.isEmpty {
                return (false, "this data is empty", value)
            }
            return (true, "success", value)
        }
        
    }
    
}






