//
//  Rule.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation


public extension Unwrap {
    
    typealias Filtered = Filter
    
    struct Filter: OptionSet {
        
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let `nil`: Filter = .init(rawValue: 1 << 0)
        public static let null: Filter = .init(rawValue: 1 << 1)
        public static let empty: Filter = .init(rawValue: 1 << 2)
        public static let none: Filter = .init(rawValue: 1 << 3)
        public static let exception: Filter = [.nil, .null, .empty]

        public func result<T>(value: Optional<T>, identity: String) -> Result<T> {
            let validate = self.element(value: value)
            if let data = validate.data {
                return .success((data, identity))
            }
            else {
                return .failure(value: value, identity: identity, reason: validate.reason)
            }
        }

        public func element<T>(value: Optional<T>) -> (data: Optional<T>, reason: String) {
            let value = Mirror.unwrap(value: value)
            if self.contains(.none) {
                return (value, "success")
            }
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




