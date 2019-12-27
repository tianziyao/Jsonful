//
//  As.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation

public extension Unwrap {
    
    struct As<T> {
        
        private let result: Unwrap.Result<T>
        
        public init(result: Unwrap.Result<T>) {
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
    }

}

public extension Unwrap.As {
    
    //MARK: ---字符串---
    
    var string: Unwrap.Result<String> {    
        return that()
    }
    
    var nsString: Unwrap.Result<NSString> {
        return that()
    }
    
    var nsMutableString: Unwrap.Result<NSMutableString> {
        return that()
    }
    
    //MARK: ---属性字符串---
    
    var nsAttributedString: Unwrap.Result<NSAttributedString> {
        return that()
    }
    
    var nsMutableAttributedString: Unwrap.Result<NSMutableAttributedString> {
        return that()
    }
    
    //MARK: ---数字---
    
    var int: Unwrap.Result<Int> {
        return that()
    }
    
    var double: Unwrap.Result<Double> {
        return that()
    }
    
    var float: Unwrap.Result<Float> {
        return that()
    }
    
    var nsNumber: Unwrap.Result<NSNumber> {
        return that()
    }
    
    //MARK: ---布尔---
    
    var bool: Unwrap.Result<Bool> {
        return that()
    }
    
    var objcBool: Unwrap.Result<ObjCBool> {
        return that()
    }
    
    //MARK: ---对象---
    
    var date: Unwrap.Result<Date> {
        return that()
    }
    
    var nsDate: Unwrap.Result<NSDate> {
        return that()
    }
    
    var data: Unwrap.Result<Data> {
        return that()
    }
    
    var nsData: Unwrap.Result<NSData> {
        return that()
    }
    
    var nsMutableData: Unwrap.Result<NSMutableData> {
        return that()
    }
    
    var range: Unwrap.Result<Range<Int>> {
        return that()
    }
    
    var nsRange: Unwrap.Result<NSRange> {
        return that()
    }
    
    var url: Unwrap.Result<URL> {
        return that()
    }
    
    var nsURL: Unwrap.Result<NSURL> {
        return that()
    }
    
    var urlRequest: Unwrap.Result<URLRequest> {
        return that()
    }
    
    var nsURLRequest: Unwrap.Result<NSURLRequest> {
        return that()
    }
    
    var nsMutableURLRequest: Unwrap.Result<NSMutableURLRequest> {
        return that()
    }
    
    var anyObject: Unwrap.Result<AnyObject> {
        return that()
    }
    
    var nsObject: Unwrap.Result<NSObject> {
        return that()
    }
    
    var nsError: Unwrap.Result<NSError> {
        return that()
    }
    
    var nsValue: Unwrap.Result<NSValue> {
        return that()
    }
    
    
    //MARK: ---UIKit对象---
    
    var image: Unwrap.Result<UIImage> {
        return that()
    }
    
    var color: Unwrap.Result<UIColor> {
        return that()
    }
    
    var font: Unwrap.Result<UIFont> {
        return that()
    }
    
    //MARK: ---CoreGraphics对象---
    
    var cgFloat: Unwrap.Result<CGFloat> {
        return that()
    }
    
    var cgSize: Unwrap.Result<CGSize> {
        return that()
    }
    
    var cgPoint: Unwrap.Result<CGPoint> {
        return that()
    }
    
    var cgRect: Unwrap.Result<CGRect> {
        return that()
    }
    
    var cgFont: Unwrap.Result<CGFont> {
        return that()
    }
    
    var cgImage: Unwrap.Result<CGImage> {
        return that()
    }
    
    var cgColor: Unwrap.Result<CGColor> {
        return that()
    }
    
    var cgPath: Unwrap.Result<CGPath> {
        return that()
    }
}



