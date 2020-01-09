# Jsonful

这是一个可以让你像 JavaScript 一样使用数据的库。



## Example

```
enum Number: Int {
    case zero, one, two
}

enum Text: String {
    case a, b, c
}

struct Enum {
    var a: Text = .a
    var zero: Number = .zero
}

class Mock {    
    var tuple: (String, Int)
    var `enum` = Enum()
    var dictionary: [AnyHashable: Any]
    var array: [Any]
    var set: Set<AnyHashable>
    var string: String
    var nsAttributedString: NSAttributedString
    var int: Int
    var bool: Bool
    var date: Date
    var data: Data
    var url: URL
    var _image: UIImage
    var _color: UIColor
    var _font: UIFont
    
    init() {
        self.tuple = ("success", 200)
        self.dictionary = ["status": "success"]
        self.array = [500, 501, 502]
        self.set = .init([500, 501, 502])
        self.string = "success"
        self.nsAttributedString = .init(string: "success")
        self.int = 0
        self.bool = true
        self.data = Data(repeating: 0, count: 10)
        self.date = Date(timeIntervalSince1970: 0)        
        self.url = URL(fileURLWithPath: "mock")
        self._image = UIImage(named: "icon")!
        self._color = .red
        self._font = .systemFont(ofSize: 16)
    }
}


let snapshot = Jsonful.snapshot(mock)

XCTAssert(snapshot.tuple.0.lint().as.string.value == "success")
XCTAssert(snapshot.tuple.1.lint().as.int.value == 200)
XCTAssert(snapshot.enum.a.lint().map(Text.self).value?.rawValue == Text.a.rawValue)
XCTAssert(snapshot.enum.zero.lint().map(Number.self).value?.rawValue == Number.zero.rawValue)
XCTAssert(snapshot.dictionary.status.lint().as.string.value == "success")
XCTAssert(snapshot.array[0].lint().as.int.value == 500)
XCTAssert(snapshot.set.lint().as.set(AnyHashable.self).value?.count == 3)
XCTAssert(snapshot.string.lint().as.string.value == "success")
XCTAssert(snapshot.int.lint().as.int.value == 0)
XCTAssert(snapshot.bool.lint().as.bool.value == true)
XCTAssert(snapshot.data.lint().as.data.value?.count == 10)
XCTAssert(snapshot.date.lint().as.date.value?.timeIntervalSince1970 == 0)
XCTAssert(snapshot.urlRequest.lint().as.urlRequest.value?.url?.path == "/mock")

XCTAssert(mock._image === snapshot.image.lint().as.that().value)
XCTAssert(snapshot.color.lint().as.that().value === mock._color)
XCTAssert(snapshot.font.lint().as.font.value === mock._font)
```



## Requirements

Swift 4.2 以上，iOS 8.0 以上。



## Installation

```ruby
pod 'Jsonful'
```

