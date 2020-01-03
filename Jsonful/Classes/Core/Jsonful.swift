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
    
    public typealias MemberMaper = (String) -> String
    
    public let raw: Any?
    
    private let tokens: [JsonfulKeyble]
    
    private let maper: MemberMaper
        
    private init(_ raw: Any?, tokens: [JsonfulKeyble], maper: MemberMaper?) {
        self.raw = raw
        self.tokens = tokens
        self.maper = maper ?? {$0}
    }
    
    /// - Parameters:
    ///   - raw: 引入的数据
    ///   - maper: 需要使用keyA取出KeyB的值，需要实现此闭包
    public static func reference(_ raw: Any?, maper: MemberMaper? = nil) -> Jsonful {
        return .init(raw, tokens: [], maper: maper)
    }
    
    /// - Parameters:
    ///   - raw: 原始数据
    ///   - ignore: 类型前缀，符合该前缀的对象不会分解为字典。默认忽略大部分标准库类型。
    ///   - depth: 递归深度
    ///   - maper: 需要使用keyA取出KeyB的值，需要实现此闭包
    public static func snapshot(_ raw: Any?, ignore: Set<String> = Mirror.ignore, depth: Int = 10, maper: MemberMaper? = nil) -> Jsonful {
        let raw = Mirror.parse(value: raw, ignore: ignore, depth: depth)
        return .init(raw, tokens: [], maper: maper)
    }
    
    /// 根据指定路径获取数据
    ///
    /// - Parameters:
    ///   - prefixes: 需要匹配的前缀，例如使用somekey取到_somekey的值
    ///   - filter: 过滤条件，默认nil和empty取值失败
    /// - Returns: 取值结果
    public func lint(_ prefixes: [String] = [".", "_"], _ filter: Unwrap.Filter = .exception, _ file: String = #file, _ line: Int = #line) -> Unwrap.Result<Any> {
        let (result, members) = value(for: tokens, prefixes: prefixes)
        return result.lint(filter, members.joined(), file, line)
    }
    
    private func value(for tokens: [JsonfulKeyble], prefixes: [String]) -> (Optional<Any>, [String]) {
        var current: Any? = self.raw
        var subscripts = [String]()
        for token in tokens {
            let token = memberMaper(token)
            subscripts.append(token.describe)
            switch token.fetch(from: current, prefixes: prefixes) {
            case .none:
                return (nil, subscripts)
            case .some(let result):
                current = Mirror.unwrap(value: result)
            }
        }
        return (current, subscripts)
    }
    
    private func memberMaper(_ token: JsonfulKeyble) -> JsonfulKeyble {
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



