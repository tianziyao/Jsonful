//
//  As.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation

public extension Unwrap {
    
    public struct As<T> {
        
        private let result: Result<T>
        
        public init(result: Result<T>) {
            self.result = result
        }
                
        public func that<O>(closure: (Result<O>.Success) -> Result<O> = {.success($0)}) -> Result<O> {
            return result.map({ (arg) -> Result<O> in
                if let data = arg.value as? O {
                    return closure((data, arg.identity))
                }
                else {
                    return .failure(value: arg.value, identity: arg.identity, reason: "this data is not <\(O.self)>")
                }
            })
        }
        
        public func that<O: Containable>() -> Result<O> {
            return that(closure: { (arg) -> Result<O> in
                if arg.value.isEmpty {
                    return .failure(value: nil, identity: arg.identity, reason: "this data is empty")
                }
                else {
                    return .success(arg)
                }
            })
        }
        
        //MARK: ---字符串---
        
        var string: Result<String> {
            return that()
        }
        
        var cfString: Result<CFString> {
            return that()
        }
        
        var nsString: Result<NSString> {
            return that()
        }
        
        var nsMutableString: Result<NSMutableString> {
            return that()
        }
        
        //MARK: ---属性字符串---
        
        var nsAttributedString: Result<NSAttributedString> {
            return that()
        }
        
        var nsMutableAttributedString: Result<NSMutableAttributedString> {
            return that()
        }
        
        //MARK: ---数字---
        
        var int: Result<Int> {
            return that()
        }
        
        var double: Result<Double> {
            return that()
        }
        
        var float: Result<Float> {
            return that()
        }
        
        var nsNumber: Result<NSNumber> {
            return that()
        }
        
        //MARK: ---布尔---
        
        var bool: Result<Bool> {
            return that()
        }
        
        var objcBool: Result<ObjCBool> {
            return that()
        }
        
        //MARK: ---对象---
        
        var date: Result<Date> {
            return that()
        }
        
        var nsDate: Result<NSDate> {
            return that()
        }
        
        var data: Result<Data> {
            return that()
        }
        
        var nsData: Result<NSData> {
            return that()
        }
        
        var range: Result<Range<Int>> {
            return that()
        }
        
        var nsRange: Result<NSRange> {
            return that()
        }
        
        var url: Result<URL> {
            return that()
        }
        
        var asNSURL: Result<NSURL> {
            return that()
        }
        
        var anyObject: Result<AnyObject> {
            return that()
        }
        
        var nsObject: Result<NSObject> {
            return that()
        }
        
        var error: Result<Error> {
            return that()
        }
        
        var nsError: Result<NSError> {
            return that()
        }
        
        var nsValue: Result<NSValue> {
            return that()
        }
        
        
        //MARK: ---UIKit对象---
        
        var image: Result<UIImage> {
            return that()
        }
        
        var color: Result<UIColor> {
            return that()
        }
        
        var font: Result<UIFont> {
            return that()
        }
        
        //MARK: ---CoreGraphics对象---
        
        var cgFloat: Result<CGFloat> {
            return that()
        }
        
        var cgSize: Result<CGSize> {
            return that()
        }
        
        var cgPoint: Result<CGPoint> {
            return that()
        }
        
        var cgRect: Result<CGRect> {
            return that()
        }
        
        var cgFont: Result<CGFont> {
            return that()
        }
        
        var cgImage: Result<CGImage> {
            return that()
        }
        
        var cgPath: Result<CGPath> {
            return that()
        }
    }

}
