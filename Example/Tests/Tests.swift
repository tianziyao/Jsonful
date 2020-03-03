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
        mock.tuple = ("success", 200)
        mock.tupleWithPropertyName = ("success", 200)
        mock.tupleOrNil = (nil, 404)
        
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.tuple = ("fail", 404)
        XCTAssert(snapshot.tuple.0.unwraper().as.string.value == "success")
        XCTAssert(snapshot.tuple.1.unwraper().as.int.value == 200)
        XCTAssert(reference.tuple.0.unwraper().as.string.value == "fail")
        XCTAssert(reference.tuple.1.unwraper().as.int.value == 404)
        
        mock.tupleWithPropertyName = ("fail", 404)
        XCTAssert(snapshot.tupleWithPropertyName.status.unwraper().as.string.value == "success")
        XCTAssert(snapshot.tupleWithPropertyName.code.unwraper().as.int.value == 200)
        XCTAssert(reference.tupleWithPropertyName.status.unwraper().as.string.value == "fail")
        XCTAssert(reference.tupleWithPropertyName.code.unwraper().as.int.value == 404)
        
        mock.tupleOrNil = ("fail", nil)
        XCTAssert(snapshot.tupleOrNil.status.unwraper().value == nil)
        XCTAssert(snapshot.tupleOrNil.code.unwraper().as.int.value == 404)
        XCTAssert(reference.tupleOrNil.status.unwraper().as.string.value == "fail")
        XCTAssert(reference.tupleOrNil.code.unwraper().value == nil)
    }
    
    
    func testEnum() {
        
        let mock = Mock()
        mock.enum.a = .a
        mock.enum.zero = .zero
        mock.enum.tuple = .tuple("success", 200)
        mock.enum.tupleWithPropertyName = .tupleWithPropertyName(status: "success", code: 200)
        
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.enum.a = .b
        XCTAssert(snapshot.enum.a.unwraper().map(Text.self).value?.rawValue == Text.a.rawValue)
        XCTAssert(reference.enum.a.unwraper().map(Text.self).value?.rawValue == Text.b.rawValue)
        
        mock.enum.zero = .one
        XCTAssert(snapshot.enum.zero.unwraper().map(Number.self).value?.rawValue == Number.zero.rawValue)
        XCTAssert(reference.enum.zero.unwraper().map(Number.self).value?.rawValue == Number.one.rawValue)
        
        mock.enum.tuple = .tuple("fail", 404)
        XCTAssert(snapshot.enum.tuple.tuple.0.unwraper().as.string.value == "success")
        XCTAssert(snapshot.enum.tuple.tuple.1.unwraper().as.int.value == 200)
        XCTAssert(reference.enum.tuple.tuple.0.unwraper().as.string.value == "fail")
        XCTAssert(reference.enum.tuple.tuple.1.unwraper().as.int.value == 404)
        
        mock.enum.tupleWithPropertyName = .tupleWithPropertyName(status: "fail", code: 404)
        XCTAssert(snapshot.enum.tupleWithPropertyName.tupleWithPropertyName.status.unwraper().as.string.value == "success")
        XCTAssert(snapshot.enum.tupleWithPropertyName.tupleWithPropertyName.code.unwraper().as.int.value == 200)
        XCTAssert(reference.enum.tupleWithPropertyName.tupleWithPropertyName.status.unwraper().as.string.value == "fail")
        XCTAssert(reference.enum.tupleWithPropertyName.tupleWithPropertyName.code.unwraper().as.int.value == 404)

    }
    
    func testArray() {
        
        let mock = Mock()
        mock.array = [100, 200, 300]
        mock.arrayOrNil = [nil, 200, 300]
        
        mock.nsArray = .init(array: [100, 200, 300])
        mock.nsArrayOrNil = .init(array: [NSNull(), 200, 300])
        mock.nsMutableArray = .init(array: [100, 200, 300])
        
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.array[0] = 101
        XCTAssert(snapshot.array[0].unwraper().as.int.value == 100)
        XCTAssert(reference.array[0].unwraper().as.int.value == 101)
        
        mock.arrayOrNil[0] = 101
        XCTAssert(snapshot.arrayOrNil[0].unwraper().value == nil)
        XCTAssert(reference.arrayOrNil[0].unwraper().as.int.value == 101)
        
        XCTAssert(snapshot.arrayOrNil.unwraper().as.array(Int?.self).value?.count == 3)
        XCTAssert(reference.arrayOrNil.unwraper().as.array(Int.self).value?.count == 3)
        
        XCTAssert(snapshot.nsArray[0].unwraper().as.int.value == 100)
        XCTAssert(reference.nsArray[0].unwraper().as.int.value == 100)
        
        XCTAssert(snapshot.nsArray.unwraper().as.nsArray().value !== mock.nsArray)
        XCTAssert(reference.nsArray.unwraper().as.nsArray().value === mock.nsArray)
        
        XCTAssert(snapshot.nsArrayOrNil[0].unwraper().value == nil)
        XCTAssert(reference.nsArrayOrNil[0].unwraper().value == nil)
        
        XCTAssert(snapshot.nsArrayOrNil[10].unwraper().value == nil)
        XCTAssert(reference.nsArrayOrNil[10].unwraper().value == nil)
        
        XCTAssert(snapshot.nsArrayOrNil.unwraper().as.nsArray().value?.count == 3)
        XCTAssert(reference.nsArrayOrNil.unwraper().as.nsArray().value?.count == 3)
        
        XCTAssert(snapshot.nsArrayOrNil.unwraper().as.nsArray().value !== mock.nsArrayOrNil)
        XCTAssert(reference.nsArrayOrNil.unwraper().as.nsArray().value === mock.nsArrayOrNil)
        
        mock.nsMutableArray.add(503)
        XCTAssert(snapshot.nsMutableArray.unwraper().as.nsMutableArray().value?.count == 3)
        XCTAssert(reference.nsMutableArray.unwraper().as.nsMutableArray().value?.count == 4)
        
        XCTAssert(snapshot.nsMutableArray.unwraper().as.nsMutableArray().value !== mock.nsMutableArray)
        XCTAssert(reference.nsMutableArray.unwraper().as.nsMutableArray().value === mock.nsMutableArray)
        
    }
    
    func testDictionary() {
        let mock = Mock()
        mock.dictionary = ["status": "success"]
        mock.dictionaryOrNil = ["status": "success", "code": nil]
        
        mock.nsDictionary = .init(dictionary: ["status": "success"])
        mock.nsDictionaryOrNil = .init(dictionary: ["status": "success", "code": NSNull()])
        mock.nsMutableDictionary = .init(dictionary: ["status": "success"])

        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.dictionary["status"] = ""
        XCTAssert(snapshot.dictionary.status.unwraper().as.string.value == "success")
        XCTAssert(reference.dictionary.status.unwraper().value == nil)

        mock.dictionaryOrNil?["code"] = 200
        XCTAssert(snapshot.dictionaryOrNil.code.unwraper().value == nil)
        XCTAssert(reference.dictionaryOrNil.code.unwraper().as.int.value == 200)
        
        XCTAssert(snapshot.dictionaryOrNil.unwraper().as.dictionary(Any.self).value?.count == 2)
        XCTAssert(reference.dictionaryOrNil.unwraper().as.dictionary(Any.self).value?.count == 2)
        
        XCTAssert(snapshot.nsDictionary.status.unwraper().as.string.value == "success")
        XCTAssert(reference.nsDictionary.status.unwraper().as.string.value == "success")
        
        XCTAssert(snapshot.nsDictionary.unwraper().as.nsDictionary().value !== mock.nsDictionary)
        XCTAssert(reference.nsDictionary.unwraper().as.nsDictionary().value === mock.nsDictionary)

        XCTAssert(snapshot.nsDictionaryOrNil.code.unwraper().value == nil)
        XCTAssert(reference.nsDictionaryOrNil.code.unwraper().value == nil)
        
        XCTAssert(snapshot.nsDictionaryOrNil.unwraper().as.nsDictionary().value?.count == 2)
        XCTAssert(reference.nsDictionaryOrNil.unwraper().as.nsDictionary().value?.count == 2)
        
        XCTAssert(snapshot.nsDictionaryOrNil.unwraper().as.nsDictionary().value !== mock.nsDictionaryOrNil)
        XCTAssert(reference.nsDictionaryOrNil.unwraper().as.nsDictionary().value === mock.nsDictionaryOrNil)
        
        mock.nsMutableDictionary.setObject(200, forKey: "code" as NSCopying)
        XCTAssert(snapshot.nsMutableDictionary.unwraper().as.nsMutableDictionary().value?.count == 1)
        XCTAssert(reference.nsMutableDictionary.unwraper().as.nsMutableDictionary().value?.count == 2)
        
        XCTAssert(snapshot.nsMutableDictionary.unwraper().as.nsMutableDictionary().value !== mock.nsMutableDictionary)
        XCTAssert(reference.nsMutableDictionary.unwraper().as.nsMutableDictionary().value === mock.nsMutableDictionary)

    }
    
    func testSet() {
        
        let mock = Mock()
        
        mock.set = .init([500, 501, 502])
        mock.setOrNil = .init([NSNull(), 501, 502])
        
        mock.nsSet = .init(array: [500, 501, 502])
        mock.nsSetOrNil = .init(array: [NSNull(), 501, 502])
        mock.nsMutableSet = .init(array: [500, 501, 502])
        
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        XCTAssert(snapshot.set.unwraper().as.set(AnyHashable.self).value?.count == 3)
        XCTAssert(reference.set.unwraper().as.set(AnyHashable.self).value?.count == 3)
        
        mock.setOrNil?.insert(503)
        XCTAssert(snapshot.setOrNil.unwraper().as.set(AnyHashable.self).value?.count == 3)
        XCTAssert(reference.setOrNil.unwraper().as.set(AnyHashable.self).value?.count == 4)

        XCTAssert(snapshot.nsSet.unwraper().as.nsSet().value?.count == 3)
        XCTAssert(reference.nsSet.unwraper().as.nsSet().value?.count == 3)
        
        XCTAssert(snapshot.nsSet.unwraper().as.nsSet().value !== mock.nsSet)
        XCTAssert(reference.nsSet.unwraper().as.nsSet().value === mock.nsSet)
        
        XCTAssert(snapshot.nsSetOrNil.unwraper().as.nsSet().value?.count == 3)
        XCTAssert(reference.nsSetOrNil.unwraper().as.nsSet().value?.count == 3)
        
        XCTAssert(snapshot.nsSetOrNil.unwraper().as.nsSet().value !== mock.nsSetOrNil)
        XCTAssert(reference.nsSetOrNil.unwraper().as.nsSet().value === mock.nsSetOrNil)
        
        mock.nsMutableSet.add(NSNull())
        mock.nsMutableSet.add(NSNull())
        mock.nsMutableSet.add(NSNull())

        XCTAssert(snapshot.nsMutableSet.unwraper().as.nsMutableSet().value?.count == 3)
        XCTAssert(reference.nsMutableSet.unwraper().as.nsMutableSet().value?.count == 4)
        
        XCTAssert(snapshot.nsMutableSet.unwraper().as.nsMutableSet().value !== mock.nsMutableSet)
        XCTAssert(reference.nsMutableSet.unwraper().as.nsMutableSet().value === mock.nsMutableSet)

    }
        
    func testText() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        mock.string = "fail"
        XCTAssert(snapshot.string.unwraper().as.string.value == "success")
        XCTAssert(reference.string.unwraper().as.string.value == "fail")
        
        XCTAssert(snapshot.nsString.unwraper().as.nsString.value === mock.nsString)
        XCTAssert(reference.nsString.unwraper().as.nsString.value === mock.nsString)
        
        XCTAssert(snapshot.nsMutableString.unwraper().as.nsMutableString.value === mock.nsMutableString)
        XCTAssert(reference.nsMutableString.unwraper().as.nsMutableString.value === mock.nsMutableString)

        XCTAssert(snapshot.nsAttributedString.unwraper().as.nsAttributedString.value === mock.nsAttributedString)
        XCTAssert(reference.nsAttributedString.unwraper().as.nsAttributedString.value === mock.nsAttributedString)
        
        XCTAssert(snapshot.nsMutableAttributedString.unwraper().as.nsMutableAttributedString.value === mock.nsMutableAttributedString)
        XCTAssert(reference.nsMutableAttributedString.unwraper().as.nsMutableAttributedString.value === mock.nsMutableAttributedString)

    }
    
    func testNumber() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
    
        XCTAssert(snapshot.int.unwraper().as.int.value == 0)
        XCTAssert(snapshot.double.unwraper().as.double.value == 0)
        XCTAssert(snapshot.float.unwraper().as.float.value == 0)
        XCTAssert(snapshot.nsNumber.unwraper().as.nsNumber.value == 0)
        
        XCTAssert(reference.int.unwraper().as.int.value == 0)
        XCTAssert(reference.double.unwraper().as.double.value == 0)
        XCTAssert(reference.float.unwraper().as.float.value == 0)
        XCTAssert(reference.nsNumber.unwraper().as.nsNumber.value == 0)
    }
    
    
    func testBool() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        XCTAssert(snapshot.bool.unwraper().as.bool.value == true)
        XCTAssert(snapshot.objcBool.unwraper().as.objcBool.value?.boolValue == true)
        
        XCTAssert(reference.bool.unwraper().as.bool.value == true)
        XCTAssert(reference.objcBool.unwraper().as.objcBool.value?.boolValue == true)
    }
    
    func testFoundationStruct() {
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        mock.data = Data()
        XCTAssert(snapshot.data.unwraper().as.data.value?.count == 10)
        XCTAssert(reference.data.unwraper().value == nil)
        
        mock.date = Date(timeIntervalSince1970: 100)
        XCTAssert(snapshot.date.unwraper().as.date.value?.timeIntervalSince1970 == 0)
        XCTAssert(reference.date.unwraper().as.date.value?.timeIntervalSince1970 == 100)
        
        mock.range = Range<Int>.init(NSRange(location: 10, length: 20))!
        XCTAssert(snapshot.range.unwraper().as.range.value?.count == 10)
        XCTAssert(reference.range.unwraper().as.range.value?.count == 20)
        
        mock.closedRange = 100 ... 300
        XCTAssert(snapshot.closedRange.unwraper().map(ClosedRange<Int>.self).value?.count == 101)
        XCTAssert(reference.closedRange.unwraper().map(ClosedRange<Int>.self).value?.count == 201)
        
        mock.url = URL(fileURLWithPath: "test")
        XCTAssert(snapshot.url.unwraper().as.url.value?.path == "/mock")
        XCTAssert(reference.url.unwraper().as.url.value?.path == "/test")
        
        mock.urlRequest = URLRequest(url: mock.url)
        XCTAssert(snapshot.urlRequest.unwraper().as.urlRequest.value?.url?.path == "/mock")
        XCTAssert(reference.urlRequest.unwraper().as.urlRequest.value?.url?.path == "/test")
        
        mock.nsRange = NSRange(location: 10, length: 20)
        XCTAssert(snapshot.nsRange.unwraper().as.nsRange.value?.length == 10)
        XCTAssert(reference.nsRange.unwraper().as.nsRange.value?.length == 20)

    }
    
    func testFoundationClass() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        XCTAssert(snapshot.nsData.unwraper().as.nsData.value === mock.nsData)
        XCTAssert(reference.nsData.unwraper().as.nsData.value === mock.nsData)
        
        XCTAssert(snapshot.nsMutableData.unwraper().as.nsMutableData.value === mock.nsMutableData)
        XCTAssert(reference.nsMutableData.unwraper().as.nsMutableData.value === mock.nsMutableData)
        
        XCTAssert(snapshot.nsDate.unwraper().as.nsDate.value === mock.nsDate)
        XCTAssert(reference.nsDate.unwraper().as.nsDate.value === mock.nsDate)
        
        XCTAssert(snapshot.nsURL.unwraper().as.nsURL.value === mock.nsURL)
        XCTAssert(reference.nsURL.unwraper().as.nsURL.value === mock.nsURL)
        
        XCTAssert(snapshot.nsURLRequest.unwraper().as.nsURLRequest.value === mock.nsURLRequest)
        XCTAssert(reference.nsURLRequest.unwraper().as.nsURLRequest.value === mock.nsURLRequest)
        
        XCTAssert(snapshot.nsMutableURLRequest.unwraper().as.nsMutableURLRequest.value === mock.nsMutableURLRequest)
        XCTAssert(reference.nsMutableURLRequest.unwraper().as.nsMutableURLRequest.value === mock.nsMutableURLRequest)
        
        XCTAssert(snapshot.anyObject.unwraper().as.anyObject.value === mock.anyObject)
        XCTAssert(reference.anyObject.unwraper().as.anyObject.value === mock.anyObject)
        
        XCTAssert(snapshot.nsObject.unwraper().as.nsObject.value === mock.nsObject)
        XCTAssert(reference.nsObject.unwraper().as.nsObject.value === mock.nsObject)
        
        XCTAssert(snapshot.nsError.unwraper().as.nsError.value === mock.nsError)
        XCTAssert(reference.nsError.unwraper().as.nsError.value === mock.nsError)
        
        XCTAssert(snapshot.nsValue.unwraper().as.nsValue.value === mock.nsValue)
        XCTAssert(reference.nsValue.unwraper().as.nsValue.value === mock.nsValue)

    }
    
    func testUIKit() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
                
        XCTAssert(mock._image === snapshot.image.unwraper().as.that().value)
        XCTAssert(mock._image === reference.image.unwraper().as.that().value)
    
        XCTAssert(snapshot.color.unwraper().as.that().value === mock._color)
        XCTAssert(reference.color.unwraper().as.that().value === mock._color)
    
        XCTAssert(snapshot.font.unwraper().as.font.value === mock._font)
        XCTAssert(reference.font.unwraper().as.font.value === mock._font)
        
    }
    
    func testCoreGraphics() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        mock.cgFloat = 100
        XCTAssert(snapshot.cgFloat.unwraper().as.cgFloat.value == 0)
        XCTAssert(reference.cgFloat.unwraper().as.cgFloat.value == mock.cgFloat)
        
        mock.cgSize = .init(width: 10, height: 10)
        XCTAssert(snapshot.cgSize.unwraper().as.cgSize.value == .zero)
        XCTAssert(reference.cgSize.unwraper().as.cgSize.value == mock.cgSize)
        
        mock.cgPoint = .init(x: 10, y: 10)
        XCTAssert(snapshot.cgPoint.unwraper().as.cgPoint.value == .zero)
        XCTAssert(reference.cgPoint.unwraper().as.cgPoint.value == mock.cgPoint)
        
        mock.cgRect = .init(x: 10, y: 10, width: 10, height: 10)
        XCTAssert(snapshot.cgRect.unwraper().as.cgRect.value == .zero)
        XCTAssert(reference.cgRect.unwraper().as.cgRect.value == mock.cgRect)
    }
}
