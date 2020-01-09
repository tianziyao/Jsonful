import XCTest
import Jsonful


class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTuple() {
        let mock = Mock()
        /*
         self.tuple = ("success", 200)
         self.tupleWithPropertyName = ("success", 200)
         self.tupleOrNil = (nil, 404)
         */
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.tuple = ("fail", 404)
        XCTAssert(snapshot.tuple.0.lint().as.string.value == "success")
        XCTAssert(snapshot.tuple.1.lint().as.int.value == 200)
        XCTAssert(reference.tuple.0.lint().as.string.value == "fail")
        XCTAssert(reference.tuple.1.lint().as.int.value == 404)
        
        mock.tupleWithPropertyName = ("fail", 404)
        XCTAssert(snapshot.tupleWithPropertyName.status.lint().as.string.value == "success")
        XCTAssert(snapshot.tupleWithPropertyName.code.lint().as.int.value == 200)
        XCTAssert(reference.tupleWithPropertyName.status.lint().as.string.value == "fail")
        XCTAssert(reference.tupleWithPropertyName.code.lint().as.int.value == 404)
        
        mock.tupleOrNil = ("fail", nil)
        XCTAssert(snapshot.tupleOrNil.status.lint().value == nil)
        XCTAssert(snapshot.tupleOrNil.code.lint().as.int.value == 404)
        XCTAssert(reference.tupleOrNil.status.lint().as.string.value == "fail")
        XCTAssert(reference.tupleOrNil.code.lint().value == nil)
    }
    
    
    func testEnum() {
        
        let mock = Mock()
        /*
         var a: Text = .a
         var zero: Number = .zero
         var tuple: Raw = .tuple("success", 200)
         var tupleWithPropertyName: Raw = .tupleWithPropertyName(status: "success", code: 200)
         */
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.enum.a = .b
        XCTAssert(snapshot.enum.a.lint().map(Text.self).value?.rawValue == Text.a.rawValue)
        XCTAssert(reference.enum.a.lint().map(Text.self).value?.rawValue == Text.b.rawValue)
        
        mock.enum.zero = .one
        XCTAssert(snapshot.enum.zero.lint().map(Number.self).value?.rawValue == Number.zero.rawValue)
        XCTAssert(reference.enum.zero.lint().map(Number.self).value?.rawValue == Number.one.rawValue)
        
        mock.enum.tuple = .tuple("fail", 404)
        XCTAssert(snapshot.enum.tuple.tuple.0.lint().as.string.value == "success")
        XCTAssert(snapshot.enum.tuple.tuple.1.lint().as.int.value == 200)
        XCTAssert(reference.enum.tuple.tuple.0.lint().as.string.value == "fail")
        XCTAssert(reference.enum.tuple.tuple.1.lint().as.int.value == 404)
        
        mock.enum.tupleWithPropertyName = .tupleWithPropertyName(status: "fail", code: 404)
        XCTAssert(snapshot.enum.tupleWithPropertyName.tupleWithPropertyName.status.lint().as.string.value == "success")
        XCTAssert(snapshot.enum.tupleWithPropertyName.tupleWithPropertyName.code.lint().as.int.value == 200)
        XCTAssert(reference.enum.tupleWithPropertyName.tupleWithPropertyName.status.lint().as.string.value == "fail")
        XCTAssert(reference.enum.tupleWithPropertyName.tupleWithPropertyName.code.lint().as.int.value == 404)

    }
    
    func testDictionary() {
        let mock = Mock()
        /*
         self.dictionary = ["status": "success"]
         self.dictionaryOrNil = ["status": "success", "code": nil]
         
         self.nsDictionary = .init(dictionary: ["status": "success"])
         self.nsDictionaryOrNil = .init(dictionary: ["status": "success", "code": NSNull()])
         self.nsMutableDictionary = .init(dictionary: self._nsDictionary)
         */
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.dictionary["status"] = ""
        XCTAssert(snapshot.dictionary.status.lint().as.string.value == "success")
        XCTAssert(reference.dictionary.status.lint().value == nil)

        mock.dictionaryOrNil?["code"] = 200
        XCTAssert(snapshot.dictionaryOrNil.code.lint().value == nil)
        XCTAssert(reference.dictionaryOrNil.code.lint().as.int.value == 200)
        
        XCTAssert(snapshot.dictionaryOrNil.lint().as.dictionary(Any.self).value?.count == 2)
        XCTAssert(reference.dictionaryOrNil.lint().as.dictionary(Any.self).value?.count == 2)
        
        XCTAssert(snapshot.dictionaryOrNil.lint().as.dictionary(Any.self, filter: .nil).value?.count == 1)
        XCTAssert(reference.dictionaryOrNil.lint().as.dictionary(Any.self, filter: .nil).value?.count == 2)
        
        XCTAssert(snapshot.nsDictionary.status.lint().as.string.value == "success")
        XCTAssert(reference.nsDictionary.status.lint().as.string.value == "success")
        
        XCTAssert(snapshot.nsDictionary.lint().as.nsDictionary().value !== mock.nsDictionary)
        XCTAssert(reference.nsDictionary.lint().as.nsDictionary().value === mock.nsDictionary)

        XCTAssert(snapshot.nsDictionaryOrNil.code.lint().value == nil)
        XCTAssert(reference.nsDictionaryOrNil.code.lint().value == nil)
        
        XCTAssert(snapshot.nsDictionaryOrNil.lint().as.nsDictionary(filter: .nil).value?.count == 1)
        XCTAssert(reference.nsDictionaryOrNil.lint().as.nsDictionary(filter: .nil).value?.count == 1)
        
        XCTAssert(snapshot.nsDictionaryOrNil.lint().as.nsDictionary().value !== mock.nsDictionaryOrNil)
        XCTAssert(reference.nsDictionaryOrNil.lint().as.nsDictionary().value === mock.nsDictionaryOrNil)
        
        mock.nsMutableDictionary.setObject(200, forKey: "code" as NSCopying)
        XCTAssert(snapshot.nsMutableDictionary.lint().as.nsMutableDictionary().value?.count == 1)
        XCTAssert(reference.nsMutableDictionary.lint().as.nsMutableDictionary().value?.count == 2)
        
        XCTAssert(snapshot.nsMutableDictionary.lint().as.nsMutableDictionary().value !== mock.nsMutableDictionary)
        XCTAssert(reference.nsMutableDictionary.lint().as.nsMutableDictionary().value === mock.nsMutableDictionary)

    }
    
    func testArray() {
        
        let mock = Mock()
        /*
         self.array = [500, 501, 502]
         self.arrayOrNil = [nil, 501, 502]
         
         self.nsArray = .init(array: [500, 501, 502])
         self.nsArrayOrNil = .init(array: [NSNull(), 501, 502])
         self.nsMutableArray = .init(array: self.array)
         */
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.array[0] = 200
        XCTAssert(snapshot.array[0].lint().as.int.value == 500)
        XCTAssert(reference.array[0].lint().as.int.value == 200)
        
        mock.arrayOrNil[0] = 200
        XCTAssert(snapshot.arrayOrNil[0].lint().value == nil)
        XCTAssert(reference.arrayOrNil[0].lint().as.int.value == 200)
        
        XCTAssert(snapshot.arrayOrNil.lint().as.array(Any.self).value?.count == 3)
        XCTAssert(reference.arrayOrNil.lint().as.array(Any.self).value?.count == 3)
        
        XCTAssert(snapshot.arrayOrNil.lint().as.array(Any.self, filter: .nil).value?.count == 2)
        XCTAssert(reference.arrayOrNil.lint().as.array(Any.self, filter: .nil).value?.count == 3)
        
        XCTAssert(snapshot.nsArray[0].lint().as.int.value == 500)
        XCTAssert(reference.nsArray[0].lint().as.int.value == 500)
        
        XCTAssert(snapshot.nsArray.lint().as.nsArray().value !== mock.nsArray)
        XCTAssert(reference.nsArray.lint().as.nsArray().value === mock.nsArray)

        XCTAssert(snapshot.nsArrayOrNil[0].lint().value == nil)
        XCTAssert(reference.nsArrayOrNil[0].lint().value == nil)
        
        XCTAssert(snapshot.nsArrayOrNil[10].lint().value == nil)
        XCTAssert(reference.nsArrayOrNil[10].lint().value == nil)
        
        XCTAssert(snapshot.nsArrayOrNil.lint().as.nsArray(filter: .nil).value?.count == 2)
        XCTAssert(reference.nsArrayOrNil.lint().as.nsArray(filter: .nil).value?.count == 2)
        
        XCTAssert(snapshot.nsArrayOrNil.lint().as.nsArray().value !== mock.nsArrayOrNil)
        XCTAssert(reference.nsArrayOrNil.lint().as.nsArray().value === mock.nsArrayOrNil)
        
        mock.nsMutableArray.add(503)
        XCTAssert(snapshot.nsMutableArray.lint().as.nsMutableArray().value?.count == 3)
        XCTAssert(reference.nsMutableArray.lint().as.nsMutableArray().value?.count == 4)
        
        XCTAssert(snapshot.nsMutableArray.lint().as.nsMutableArray().value !== mock.nsMutableArray)
        XCTAssert(reference.nsMutableArray.lint().as.nsMutableArray().value === mock.nsMutableArray)

    }
    
    func testSet() {
        
        let mock = Mock()
        /*
         self.set = .init([500, 501, 502])
         self.setOrNil = .init([NSNull(), 501, 502])
         
         self.nsSet = .init(array: [500, 501, 502])
         self.nsSetOrNil = .init(array: [NSNull(), 501, 502])
         self.nsMutableSet = .init(array: self.array)
         */
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        XCTAssert(snapshot.set.lint().as.set(AnyHashable.self).value?.count == 3)
        XCTAssert(reference.set.lint().as.set(AnyHashable.self).value?.count == 3)
        
        mock.setOrNil?.insert(503)
        XCTAssert(snapshot.setOrNil.lint().as.set(AnyHashable.self, filter: .nil).value?.count == 2)
        XCTAssert(reference.setOrNil.lint().as.set(AnyHashable.self, filter: .nil).value?.count == 3)

        XCTAssert(snapshot.nsSet.lint().as.nsSet().value?.count == 3)
        XCTAssert(reference.nsSet.lint().as.nsSet().value?.count == 3)
        
        XCTAssert(snapshot.nsSet.lint().as.nsSet().value !== mock.nsSet)
        XCTAssert(reference.nsSet.lint().as.nsSet().value === mock.nsSet)
        
        XCTAssert(snapshot.nsSetOrNil.lint().as.nsSet(filter: .nil).value?.count == 2)
        XCTAssert(reference.nsSetOrNil.lint().as.nsSet(filter: .nil).value?.count == 2)
        
        XCTAssert(snapshot.nsSetOrNil.lint().as.nsSet().value !== mock.nsSetOrNil)
        XCTAssert(reference.nsSetOrNil.lint().as.nsSet().value === mock.nsSetOrNil)
        
        mock.nsMutableSet.add(NSNull())
        mock.nsMutableSet.add(NSNull())
        mock.nsMutableSet.add(NSNull())

        XCTAssert(snapshot.nsMutableSet.lint().as.nsMutableSet().value?.count == 3)
        XCTAssert(reference.nsMutableSet.lint().as.nsMutableSet().value?.count == 4)
        
        XCTAssert(snapshot.nsMutableSet.lint().as.nsMutableSet().value !== mock.nsMutableSet)
        XCTAssert(reference.nsMutableSet.lint().as.nsMutableSet().value === mock.nsMutableSet)

    }
        
    func testText() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        mock.string = "fail"
        XCTAssert(snapshot.string.lint().as.string.value == "success")
        XCTAssert(reference.string.lint().as.string.value == "fail")
        
        XCTAssert(snapshot.nsString.lint().as.nsString.value === mock.nsString)
        XCTAssert(reference.nsString.lint().as.nsString.value === mock.nsString)
        
        XCTAssert(snapshot.nsMutableString.lint().as.nsMutableString.value === mock.nsMutableString)
        XCTAssert(reference.nsMutableString.lint().as.nsMutableString.value === mock.nsMutableString)

        XCTAssert(snapshot.nsAttributedString.lint().as.nsAttributedString.value === mock.nsAttributedString)
        XCTAssert(reference.nsAttributedString.lint().as.nsAttributedString.value === mock.nsAttributedString)
        
        XCTAssert(snapshot.nsMutableAttributedString.lint().as.nsMutableAttributedString.value === mock.nsMutableAttributedString)
        XCTAssert(reference.nsMutableAttributedString.lint().as.nsMutableAttributedString.value === mock.nsMutableAttributedString)

    }
    
    func testNumber() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
    
        XCTAssert(snapshot.int.lint().as.int.value == 0)
        XCTAssert(snapshot.double.lint().as.double.value == 0)
        XCTAssert(snapshot.float.lint().as.float.value == 0)
        XCTAssert(snapshot.nsNumber.lint().as.nsNumber.value == 0)
        
        XCTAssert(reference.int.lint().as.int.value == 0)
        XCTAssert(reference.double.lint().as.double.value == 0)
        XCTAssert(reference.float.lint().as.float.value == 0)
        XCTAssert(reference.nsNumber.lint().as.nsNumber.value == 0)
    }
    
    
    func testBool() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        XCTAssert(snapshot.bool.lint().as.bool.value == true)
        XCTAssert(snapshot.objcBool.lint().as.objcBool.value?.boolValue == true)
        
        XCTAssert(reference.bool.lint().as.bool.value == true)
        XCTAssert(reference.objcBool.lint().as.objcBool.value?.boolValue == true)
    }
    
    func testFoundationStruct() {
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        mock.data = Data()
        XCTAssert(snapshot.data.lint().as.data.value?.count == 10)
        XCTAssert(reference.data.lint().value == nil)
        
        mock.date = Date(timeIntervalSince1970: 100)
        XCTAssert(snapshot.date.lint().as.date.value?.timeIntervalSince1970 == 0)
        XCTAssert(reference.date.lint().as.date.value?.timeIntervalSince1970 == 100)
        
        mock.range = Range<Int>.init(NSRange(location: 10, length: 20))!
        XCTAssert(snapshot.range.lint().as.range.value?.count == 10)
        XCTAssert(reference.range.lint().as.range.value?.count == 20)
        
        mock.closedRange = 100 ... 300
        XCTAssert(snapshot.closedRange.lint().map(ClosedRange<Int>.self).value?.count == 101)
        XCTAssert(reference.closedRange.lint().map(ClosedRange<Int>.self).value?.count == 201)
        
        mock.url = URL(fileURLWithPath: "test")
        XCTAssert(snapshot.url.lint().as.url.value?.path == "/mock")
        XCTAssert(reference.url.lint().as.url.value?.path == "/test")
        
        mock.urlRequest = URLRequest(url: mock.url)
        XCTAssert(snapshot.urlRequest.lint().as.urlRequest.value?.url?.path == "/mock")
        XCTAssert(reference.urlRequest.lint().as.urlRequest.value?.url?.path == "/test")
        
        mock.nsRange = NSRange(location: 10, length: 20)
        XCTAssert(snapshot.nsRange.lint().as.nsRange.value?.length == 10)
        XCTAssert(reference.nsRange.lint().as.nsRange.value?.length == 20)

    }
    
    func testFoundationClass() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        XCTAssert(snapshot.nsData.lint().as.nsData.value === mock.nsData)
        XCTAssert(reference.nsData.lint().as.nsData.value === mock.nsData)
        
        XCTAssert(snapshot.nsMutableData.lint().as.nsMutableData.value === mock.nsMutableData)
        XCTAssert(reference.nsMutableData.lint().as.nsMutableData.value === mock.nsMutableData)
        
        XCTAssert(snapshot.nsDate.lint().as.nsDate.value === mock.nsDate)
        XCTAssert(reference.nsDate.lint().as.nsDate.value === mock.nsDate)
        
        XCTAssert(snapshot.nsURL.lint().as.nsURL.value === mock.nsURL)
        XCTAssert(reference.nsURL.lint().as.nsURL.value === mock.nsURL)
        
        XCTAssert(snapshot.nsURLRequest.lint().as.nsURLRequest.value === mock.nsURLRequest)
        XCTAssert(reference.nsURLRequest.lint().as.nsURLRequest.value === mock.nsURLRequest)
        
        XCTAssert(snapshot.nsMutableURLRequest.lint().as.nsMutableURLRequest.value === mock.nsMutableURLRequest)
        XCTAssert(reference.nsMutableURLRequest.lint().as.nsMutableURLRequest.value === mock.nsMutableURLRequest)
        
        XCTAssert(snapshot.anyObject.lint().as.anyObject.value === mock.anyObject)
        XCTAssert(reference.anyObject.lint().as.anyObject.value === mock.anyObject)
        
        XCTAssert(snapshot.nsObject.lint().as.nsObject.value === mock.nsObject)
        XCTAssert(reference.nsObject.lint().as.nsObject.value === mock.nsObject)
        
        XCTAssert(snapshot.nsError.lint().as.nsError.value === mock.nsError)
        XCTAssert(reference.nsError.lint().as.nsError.value === mock.nsError)
        
        XCTAssert(snapshot.nsValue.lint().as.nsValue.value === mock.nsValue)
        XCTAssert(reference.nsValue.lint().as.nsValue.value === mock.nsValue)

    }
    
    func testUIKit() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
                
        XCTAssert(mock._image === snapshot.image.lint().as.that().value)
        XCTAssert(mock._image === reference.image.lint().as.that().value)
    
        XCTAssert(snapshot.color.lint().as.that().value === mock._color)
        XCTAssert(reference.color.lint().as.that().value === mock._color)
    
        XCTAssert(snapshot.font.lint().as.font.value === mock._font)
        XCTAssert(reference.font.lint().as.font.value === mock._font)
        
    }
    
    func testCoreGraphics() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        mock.cgFloat = 100
        XCTAssert(snapshot.cgFloat.lint().as.cgFloat.value == 0)
        XCTAssert(reference.cgFloat.lint().as.cgFloat.value == mock.cgFloat)
        
        mock.cgSize = .init(width: 10, height: 10)
        XCTAssert(snapshot.cgSize.lint().as.cgSize.value == .zero)
        XCTAssert(reference.cgSize.lint().as.cgSize.value == mock.cgSize)
        
        mock.cgPoint = .init(x: 10, y: 10)
        XCTAssert(snapshot.cgPoint.lint().as.cgPoint.value == .zero)
        XCTAssert(reference.cgPoint.lint().as.cgPoint.value == mock.cgPoint)
        
        mock.cgRect = .init(x: 10, y: 10, width: 10, height: 10)
        XCTAssert(snapshot.cgRect.lint().as.cgRect.value == .zero)
        XCTAssert(reference.cgRect.lint().as.cgRect.value == mock.cgRect)
    }
}
