//
//  Jsonful.swift
//  Demo
//
//  Created by Tian on 2019/12/3.
//  Copyright © 2019 Tian. All rights reserved.
//

import Foundation


@dynamicMemberLookup
public struct Jsonful {
    
    public typealias Maper = (JsonfulKeyble) -> JsonfulKeyble
    
    private let raw: Any?
    
    private let tokens: [JsonfulKeyble]
    
    private let maper: Maper
    
    public var current: Any? {
        return value(for: tokens).0
    }
    
    private init(_ raw: Any?, tokens: [JsonfulKeyble], maper: @escaping Maper) {
        self.raw = raw
        self.tokens = tokens
        self.maper = maper
    }
    
    public static func reference(_ raw: Any?, maper: @escaping Maper = {$0}) -> Jsonful {
        return .init(raw, tokens: [], maper: maper)
    }
    
    public static func snapshot(_ raw: Any?, depth: Int = 10, maper: @escaping Maper = {$0}) -> Jsonful {
        return .init(Mirror.parse(value: raw, depth: depth), tokens: [], maper: maper)
    }
    
    public func unwrap(file: String = #file, line: Int = #line) -> Unwrap.Result<Any> {
        let (result, members) = value(for: tokens)
        return .init(value: result, file: file, line: line, id: members.joined())
    }
    
    private func value(for tokens: [JsonfulKeyble]) -> (Optional<Any>, [String]) {
        var current: Any? = self.raw
        var subscripts = [String]()
        
        for token in tokens {
            let token = maper(token)
            subscripts.append(token.describe)
            if let result = token.fetch(from: current) {
                current = Mirror.unwrap(value: result)
            }
            else {
                return (.none, subscripts)
            }
        }
        return (current, subscripts)
    }
    
    private func append(token: JsonfulKeyble) -> Jsonful {
        var tokens = self.tokens
        tokens.append(token)
        return Jsonful(raw, tokens: tokens, maper: maper)
    }

    public subscript(dynamicMember member: String) -> Jsonful {
        return append(token: member)
    }
    
    public subscript(index: Int) -> Jsonful {
        return append(token: index)
    }

}


