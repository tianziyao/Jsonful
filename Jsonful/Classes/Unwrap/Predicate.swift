//
//  Rule.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation


public extension Unwrap {
        
    struct Predicate: OptionSet {
        
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let `nil`: Predicate = .init(rawValue: 1 << 0)
        public static let null: Predicate = .init(rawValue: 1 << 1)
        public static let empty: Predicate = .init(rawValue: 1 << 2)
        public static let exception: Predicate = [.nil, .null, .empty]

        public func result<T>(value: Optional<T>, identity: String) -> Result<T> {
            let validate = self.validate(value: value)
            if let value = validate.value {
                return .success((value, identity))
            }
            else {
                return .failure(value: value, identity: identity, reason: validate.reason)
            }
        }
        
        public func validate<T>(value: Optional<T>) -> (value: Optional<T>, reason: String) {
            let value = Mirror.unwrap(value: value)
            if value == nil && self.contains(.nil) {
                return (nil, "this data is nil")
            }
            if value is NSNull && self.contains(.null) {
                return (nil, "this data is null")
            }
            if let data = value as? Containable, self.contains(.empty), data.isEmpty {
                return (nil, "this data is empty")
            }
            if let data = value {
                return (data, "success")
            }
            else {
                return (nil, "this data is exception")
            }
        }
        
    }
    
}




