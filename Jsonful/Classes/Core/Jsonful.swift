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
    
    public typealias Maper = (String) -> String
    
    private let raw: Any?
    
    private let tokens: [JsonfulKeyble]
    
    private let maper: Maper
    
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
    
    public func unwrap(filter: Unwrap.Predicate = .exception, file: String = #file, line: Int = #line) -> Unwrap.Result<Any> {
        let (result, members) = value(for: tokens)
        return result.unwrap(id: members.joined(), filter: filter, file: file, line: line)
    }
    
    private func value(for tokens: [JsonfulKeyble]) -> (Optional<Any>, [String]) {
        var current: Any? = self.raw
        var subscripts = [String]()
        for token in tokens {
            let token = tokenMap(token)
            subscripts.append(token.describe)
            switch token.fetch(from: current) {
            case .none:
                return (current, subscripts)
            case .some(let result):
                current = Mirror.unwrap(value: result)
            }
        }
        return (current, subscripts)
    }
    
    private func tokenMap(_ token: JsonfulKeyble) -> JsonfulKeyble {
        if let string = token as? String {
            return maper(string)
        }
        else {
            return token
        }
    }
    
    private func append(token: JsonfulKeyble) -> Jsonful {
        var tokens = self.tokens
        tokens.append(token)
        return Jsonful(raw, tokens: tokens, maper: maper)
    }

    public subscript(dynamicMember member: String) -> Jsonful {
        set {
            fatalError("暂不支持写操作")
        }
        get {
            return append(token: member)
        }
    }
    
    public subscript(index: Int) -> Jsonful {
        set {
            fatalError("暂不支持写操作")
        }
        get {
            return append(token: index)
        }
    }

}



