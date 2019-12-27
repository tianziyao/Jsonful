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
    
    func testSnapshot() {
        
        let value = Mock()
        let mock = Jsonful.snapshot(value)

        let tuple = mock.tuple
        XCTAssert(tuple.0.lint().as.string.value == "success")
        XCTAssert(tuple.1.lint().as.int.value == 200)

        let tupleWithPropertyName = mock.tupleWithPropertyName
        XCTAssert(tupleWithPropertyName.status.lint().as.string.value == "success")
        XCTAssert(tupleWithPropertyName.code.lint().as.int.value == 200)

        let tupleOrNil = mock.tupleOrNil
        XCTAssert(tupleOrNil.status.lint().value == nil)
        XCTAssert(tupleOrNil.code.lint().as.int.value == 404)
        
        let enums = mock.enum
        XCTAssert(enums.a.lint().map(Text.self).value?.rawValue == Text.a.rawValue)
        XCTAssert(enums.zero.lint().map(Number.self).value?.rawValue == Number.zero.rawValue)
        XCTAssert(enums.tuple.tuple.0.lint().as.string.value == "success")
        XCTAssert(enums.tuple.tuple.1.lint().as.int.value == 200)
        XCTAssert(enums.tupleWithPropertyName.tupleWithPropertyName.status.lint().as.string.value == "success")
        XCTAssert(enums.tupleWithPropertyName.tupleWithPropertyName.code.lint().as.int.value == 200)
        
        let dictionary = mock.dictionary
        XCTAssert(dictionary.key.lint().as.string.value == "value")

        let dictionaryOrNil = mock.dictionaryOrNil
        XCTAssert(dictionaryOrNil.nil.lint().value == nil)

        let nsDictionary = mock.nsDictionary
        XCTAssert(nsDictionary.key.lint().as.string.value == "value")

        let nsDictionaryOrNil = mock.nsDictionaryOrNil
        XCTAssert(nsDictionaryOrNil.null.lint().value == nil)

        let nsMutableDictionary = mock.nsMutableDictionary
        XCTAssert(nsMutableDictionary.lint().as.dictionary(AnyHashable.self).value != nil)
        XCTAssert(nsMutableDictionary.lint().as.nsMutableDictionary().value == nil)

        let array = mock.array
        XCTAssert(array[0].lint().as.int.value == 500)

        let arrayOrNil = mock.arrayOrNil
        XCTAssert(arrayOrNil[0].lint().value == nil)

        let nsArray = mock.nsArray
        XCTAssert(nsArray[0].lint().as.int.value == 500)

        let nsArrayOrNil = mock.nsArrayOrNil
        XCTAssert(nsArrayOrNil[0].lint().value == nil)

        let nsMutableArray = mock.nsMutableArray
        XCTAssert(nsMutableArray.lint().as.array(Any.self).value != nil)
        XCTAssert(nsMutableArray.lint().as.nsMutableArray().value == nil)

        let set = mock.set
        XCTAssert(set.lint().as.set(AnyHashable.self).value?.count == 3)

        let setOrNil = mock.setOrNil
        XCTAssert(setOrNil.lint().as.set(AnyHashable.self, predicate: .exception).value?.count == 2)

        let nsSet = mock.nsSet
        XCTAssert(nsSet.lint().as.nsSet().value?.count == 3)

        let nsSetOrNil = mock.nsSetOrNil
        XCTAssert(nsSetOrNil.lint().as.nsSet(predicate: .exception).value?.count == 2)

        let nsMutableSet = mock.nsMutableSet
        XCTAssert(nsMutableSet.lint().as.set(AnyHashable.self).value != nil)
        XCTAssert(nsMutableSet.lint().as.nsMutableSet().value == nil)

    }
    
    func testReference() {
        
        let value = Mock()
        let mock = Jsonful.reference(value)
        
        let tuple = mock.tuple
        value.tuple = ("fail", 404)

        XCTAssert(tuple.0.lint().as.string.value == "fail")
        XCTAssert(tuple.1.lint().as.int.value == 404)

        let tupleWithPropertyName = mock.tupleWithPropertyName
        value.tupleWithPropertyName = ("fail", 404)

        XCTAssert(tupleWithPropertyName.status.lint().as.string.value == "fail")
        XCTAssert(tupleWithPropertyName.code.lint().as.int.value == 404)

        let tupleOrNil = mock.tupleOrNil
        value.tupleOrNil = ("fail", nil)

        XCTAssert(tupleOrNil.status.lint().as.string.value == "fail")
        XCTAssert(tupleOrNil.code.lint().value == nil)
        
        let enums = mock.enum
        XCTAssert(enums.a.lint().map(Text.self).value?.rawValue == Text.a.rawValue)
        XCTAssert(enums.zero.lint().map(Number.self).value?.rawValue == Number.zero.rawValue)
        XCTAssert(enums.tuple.tuple.0.lint().as.string.value == "success")
        XCTAssert(enums.tuple.tuple.1.lint().as.int.value == 200)
        XCTAssert(enums.tupleWithPropertyName.tupleWithPropertyName.status.lint().as.string.value == "success")
        XCTAssert(enums.tupleWithPropertyName.tupleWithPropertyName.code.lint().as.int.value == 200)

        let dictionary = mock.dictionary
        value.dictionary["key"] = ""
        XCTAssert(dictionary.key.lint().value == nil)

        let dictionaryOrNil = mock.dictionaryOrNil
        value.dictionaryOrNil?["nil"] = "value"
        XCTAssert(dictionaryOrNil.nil.lint().as.string.value == "value")

        let nsDictionary = mock.nsDictionary
        XCTAssert(nsDictionary.key.lint().as.string.value == "value")
        
        let nsDictionaryOrNil = mock.nsDictionaryOrNil
        XCTAssert(nsDictionaryOrNil.null.lint().value == nil)

        let nsMutableDictionary = mock.nsMutableDictionary
        nsMutableDictionary.lint().as.nsMutableDictionary().success { (dic) in
            XCTAssert(dic.count == 1)
            dic.removeAllObjects()
        }
        XCTAssert(nsMutableDictionary.lint().value == nil)

        let array = mock.array
        XCTAssert(array[0].lint().as.int.value == 500)

        let arrayOrNil = mock.arrayOrNil
        XCTAssert(arrayOrNil[0].lint().value == nil)

        let nsArray = mock.nsArray
        XCTAssert(nsArray[0].lint().as.int.value == 500)

        let nsArrayOrNil = mock.nsArrayOrNil
        XCTAssert(nsArrayOrNil[0].lint().value == nil)

        let nsMutableArray = mock.nsMutableArray
        nsMutableArray.lint().as.nsMutableArray().success { (arr) in
            XCTAssert(arr.count == 3)
            arr.removeAllObjects()
        }
        XCTAssert(nsMutableArray.lint().value == nil)

        let set = mock.set
        XCTAssert(set.lint().as.set(AnyHashable.self).value?.count == 3)

        let setOrNil = mock.setOrNil
        XCTAssert(setOrNil.lint().as.set(AnyHashable.self, predicate: .exception).value?.count == 2)

        let nsSet = mock.nsSet
        XCTAssert(nsSet.lint().as.nsSet().value?.count == 3)

        let nsSetOrNil = mock.nsSetOrNil
        XCTAssert(nsSetOrNil.lint().as.nsSet(predicate: .exception).value?.count == 2)

        let nsMutableSet = mock.nsMutableSet
        nsMutableSet.lint().as.nsMutableSet().success { (set) in
            XCTAssert(set.count == 3)
            set.removeAllObjects()
        }
        XCTAssert(nsMutableSet.lint().value == nil)

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
        XCTAssert(snapshot.nsMutableString.lint().as.nsMutableString.value == "success")
        reference.nsMutableString.lint().as.nsMutableString.success { (value) in
            XCTAssert(value == "success200")
            value.deleteCharacters(in: NSRange.init(location: 0, length: value.length))
        }
        XCTAssert(mock.nsMutableString == "")
        
        mock.nsMutableAttributedString.append(.init(string: "200"))
        XCTAssert(snapshot.nsMutableAttributedString.lint().as.nsMutableAttributedString.value?.string == "success")
        reference.nsMutableAttributedString.lint().as.nsMutableAttributedString.success { (value) in
            XCTAssert(value.string == "success200")
            value.deleteCharacters(in: NSRange.init(location: 0, length: value.length))
        }
        XCTAssert(mock.nsMutableAttributedString.string == "")
    
    }
    
}
