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
         self.nsMutableDictionary = .init(dictionary: self.nsDictionary)
         */
        let snapshot = Jsonful.snapshot(mock)
        let reference = Jsonful.reference(mock)
        
        mock.dictionary["status"] = ""
        XCTAssert(snapshot.dictionary.status.lint().as.string.value == "success")
        XCTAssert(reference.dictionary.status.lint().value == nil)

        mock.dictionaryOrNil?["code"] = 200
        XCTAssert(snapshot.dictionaryOrNil.code.lint().value == nil)
        XCTAssert(reference.dictionaryOrNil.code.lint().as.int.value == 200)
        
        XCTAssert(snapshot.nsDictionary.status.lint().as.string.value == "success")
        XCTAssert(reference.nsDictionary.status.lint().as.string.value == "success")
        
        XCTAssert(snapshot.nsDictionary.lint().as.nsDictionary().value !== mock.nsDictionary)
        XCTAssert(reference.nsDictionary.lint().as.nsDictionary().value === mock.nsDictionary)

        XCTAssert(snapshot.nsDictionaryOrNil.code.lint().value == nil)
        XCTAssert(reference.nsDictionaryOrNil.code.lint().value == nil)
        
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
        
        XCTAssert(snapshot.nsArray[0].lint().as.int.value == 500)
        XCTAssert(reference.nsArray[0].lint().as.int.value == 500)
        
        XCTAssert(snapshot.nsArray.lint().as.nsArray().value !== mock.nsArray)
        XCTAssert(reference.nsArray.lint().as.nsArray().value === mock.nsArray)

        XCTAssert(snapshot.nsArrayOrNil[0].lint().value == nil)
        XCTAssert(reference.nsArrayOrNil[0].lint().value == nil)
        
        XCTAssert(snapshot.nsArrayOrNil[10].lint().value == nil)
        XCTAssert(reference.nsArrayOrNil[10].lint().value == nil)
        
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

        XCTAssert(snapshot.setOrNil.lint().as.set(AnyHashable.self, filter: .exception).value?.count == 2)
        XCTAssert(reference.setOrNil.lint().as.set(AnyHashable.self, filter: .exception).value?.count == 2)

        XCTAssert(snapshot.nsSet.lint().as.nsSet().value?.count == 3)
        XCTAssert(reference.nsSet.lint().as.nsSet().value?.count == 3)

        XCTAssert(snapshot.nsSetOrNil.lint().as.nsSet(filter: .exception).value?.count == 2)
        XCTAssert(reference.nsSetOrNil.lint().as.nsSet(filter: .exception).value?.count == 2)

        XCTAssert(snapshot.nsMutableSet.lint().as.set(AnyHashable.self).value != nil)
        XCTAssert(snapshot.nsMutableSet.lint().as.nsMutableSet().value != nil)
        
        reference.nsMutableSet.lint().as.nsMutableSet().success { (set) in
            XCTAssert(set.count == 3)
            set.removeAllObjects()
        }
        XCTAssert(reference.nsMutableSet.lint().value == nil)
    }
        
    func testText() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        mock.string = "fail"
        XCTAssert(snapshot.string.lint().as.string.value == "success")
        XCTAssert(reference.string.lint().as.string.value == "fail")
        
        mock.nsString = ""
        XCTAssert(snapshot.nsString.lint().as.nsString.value == "success")
        XCTAssert(reference.nsString.lint().as.nsString.value == nil)
        
        mock.nsAttributedString = .init(string: "fail")
        XCTAssert(snapshot.nsAttributedString.lint().as.nsAttributedString.value?.string == "success")
        XCTAssert(reference.nsAttributedString.lint().as.nsAttributedString.value?.string == "fail")
        
        mock.nsMutableString.append("200")
        XCTAssert(snapshot.nsMutableString.lint().as.nsMutableString.value == "success200")
        
        mock.nsMutableAttributedString.append(.init(string: "200"))
        XCTAssert(snapshot.nsMutableAttributedString.lint().as.nsMutableAttributedString.value?.string == "success200")
    
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
    
    func testObject() {
        
        let mock = Mock()
        let reference = Jsonful.reference(mock)
        let snapshot = Jsonful.snapshot(mock)
        
        XCTAssert(snapshot.date.lint().as.date.value?.timeIntervalSince1970 == 0)
        XCTAssert(snapshot.nsDate.lint().as.nsDate.value?.timeIntervalSince1970 == 0)
        
        XCTAssert(snapshot.data.lint().as.data.value?.count == 10)
        XCTAssert(snapshot.nsData.lint(.nil).as.nsData.value?.length == 0)
        XCTAssert(snapshot.nsMutableData.lint(.nil).as.nsMutableData.value?.length == 0)
        
        XCTAssert(snapshot.nsRange.lint().as.nsRange.value?.length == 10)
        XCTAssert(snapshot.range.lint().as.range.value?.count == 10)
        XCTAssert(snapshot.closedRange.lint().map(ClosedRange<Int>.self).value?.count == 101)
        
        XCTAssert(snapshot.url.lint().as.url.value?.path == "/mock")
        XCTAssert(snapshot.nsURL.lint().as.nsURL.value?.path == "/mock")
        
        XCTAssert(snapshot.urlRequest.lint().as.urlRequest.value?.url?.path == "/mock")
        XCTAssert(snapshot.nsURLRequest.lint().as.nsURLRequest.value?.url?.path == "/mock")
        XCTAssert(snapshot.nsMutableURLRequest.lint().as.nsMutableURLRequest.value?.url?.path == "/mock")
        
        XCTAssert(snapshot.anyObject.lint().as.anyObject.value?.hash == mock.anyObject.hash)
        XCTAssert(snapshot.nsObject.lint().as.nsObject.value?.hash == mock.nsObject.hash)
        
        XCTAssert(snapshot.nsError.lint().as.nsError.value?.code == 0)
        
        XCTAssert(snapshot.nsValue.lint().as.nsValue.value?.cgSizeValue == .zero)
    
        
        XCTAssert(reference.date.lint().as.date.value?.timeIntervalSince1970 == 0)
        XCTAssert(reference.nsDate.lint().as.nsDate.value?.timeIntervalSince1970 == 0)
        
        XCTAssert(reference.data.lint().as.data.value?.count == 10)
        XCTAssert(reference.nsData.lint(.nil).as.nsData.value?.length == 0)
        XCTAssert(reference.nsMutableData.lint(.nil).as.nsMutableData.value?.length == 0)
        
        XCTAssert(reference.nsRange.lint().as.nsRange.value?.length == 10)
        XCTAssert(reference.range.lint().as.range.value?.count == 10)
        XCTAssert(reference.closedRange.lint().map(ClosedRange<Int>.self).value?.count == 101)
        
        XCTAssert(reference.url.lint().as.url.value?.path == "/mock")
        XCTAssert(reference.nsURL.lint().as.nsURL.value?.path == "/mock")
        
        XCTAssert(reference.urlRequest.lint().as.urlRequest.value?.url?.path == "/mock")
        XCTAssert(reference.nsURLRequest.lint().as.nsURLRequest.value?.url?.path == "/mock")
        XCTAssert(reference.nsMutableURLRequest.lint().as.nsMutableURLRequest.value?.url?.path == "/mock")
        
        XCTAssert(reference.anyObject.lint().as.anyObject.value?.hash == mock.anyObject.hash)
        XCTAssert(reference.nsObject.lint().as.nsObject.value?.hash == mock.nsObject.hash)
        
        XCTAssert(reference.nsError.lint().as.nsError.value?.code == 0)
        
        XCTAssert(reference.nsValue.lint().as.nsValue.value?.cgSizeValue == .zero)
    }
}
