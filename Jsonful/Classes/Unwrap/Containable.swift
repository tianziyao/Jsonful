//
//  Containable.swift
//  Jsonful
//
//  Created by Tian on 2019/12/19.
//

import Foundation

public protocol Containable {
    var isEmpty: Bool { get }
}

extension String: Containable {}

extension Array: Containable {}

extension Dictionary: Containable {}

extension Set: Containable {}

extension Data: Containable {}

extension Range: Containable {}

extension ClosedRange: Containable {}

extension NSString: Containable {
    public var isEmpty: Bool {
        return length == 0
    }
}

extension NSAttributedString: Containable {
    public var isEmpty: Bool {
        return length == 0
    }
}

extension NSArray: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSPointerArray: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSDictionary: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

@objc extension NSMapTable: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSSet: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSOrderedSet: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

@objc extension NSHashTable: Containable {
    public var isEmpty: Bool {
        return count == 0
    }
}

extension NSData: Containable {
    public var isEmpty: Bool {
        return length == 0
    }
}

extension NSRange: Containable {
    public var isEmpty: Bool {
        return length <= 0
    }
}
