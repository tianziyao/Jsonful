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
        XCTAssert(tuple.0.unwrap().as.string.value == "success")
        XCTAssert(tuple.1.unwrap().as.int.value == 200)

        let tupleWithPropertyName = mock.tupleWithPropertyName
        XCTAssert(tupleWithPropertyName.status.unwrap().as.string.value == "success")
        XCTAssert(tupleWithPropertyName.code.unwrap().as.int.value == 200)

        let tupleOrNil = mock.tupleOrNil
        XCTAssert(tupleOrNil.status.unwrap().value == nil)
        XCTAssert(tupleOrNil.code.unwrap().as.int.value == 404)

        let dictionary = mock.dictionary
        XCTAssert(dictionary.key.unwrap().as.string.value == "value")

        let dictionaryOrNil = mock.dictionaryOrNil
        XCTAssert(dictionaryOrNil.nil.unwrap().value == nil)

        let nsDictionary = mock.nsDictionary
        XCTAssert(nsDictionary.key.unwrap().as.string.value == "value")

        let nsDictionaryOrNil = mock.nsDictionaryOrNil
        XCTAssert(nsDictionaryOrNil.null.unwrap().value == nil)

        let nsMutableDictionary = mock.nsMutableDictionary
        XCTAssert(nsMutableDictionary.unwrap().as.dictionary(AnyHashable.self).value != nil)
        XCTAssert(nsMutableDictionary.unwrap().as.nsMutableDictionary().value == nil)

        let array = mock.array
        XCTAssert(array[0].unwrap().as.int.value == 500)

        let arrayOrNil = mock.arrayOrNil
        XCTAssert(arrayOrNil[0].unwrap().value == nil)

        let nsArray = mock.nsArray
        XCTAssert(nsArray[0].unwrap().as.int.value == 500)

        let nsArrayOrNil = mock.nsArrayOrNil
        XCTAssert(nsArrayOrNil[0].unwrap().value == nil)

        let nsMutableArray = mock.nsMutableArray
        XCTAssert(nsMutableArray.unwrap().as.array(Any.self).value != nil)
        XCTAssert(nsMutableArray.unwrap().as.nsMutableArray().value == nil)

        let set = mock.set
        XCTAssert(set.unwrap().as.set(AnyHashable.self).value?.count == 3)

        let setOrNil = mock.setOrNil
        XCTAssert(setOrNil.unwrap().as.set(AnyHashable.self, predicate: .exception).value?.count == 2)

        let nsSet = mock.nsSet
        XCTAssert(nsSet.unwrap().as.nsSet().value?.count == 3)

        let nsSetOrNil = mock.nsSetOrNil
        XCTAssert(nsSetOrNil.unwrap().as.nsSet(predicate: .exception).value?.count == 2)

        let nsMutableSet = mock.nsMutableSet
        XCTAssert(nsMutableSet.unwrap().as.set(AnyHashable.self).value != nil)
        XCTAssert(nsMutableSet.unwrap().as.nsMutableSet().value == nil)

    }
    
    func testReference() {
        
        let value = Mock()
        let mock = Jsonful.reference(value)
        
        let tuple = mock.tuple
        value.tuple = ("fail", 404)

        XCTAssert(tuple.0.unwrap().as.string.value == "fail")
        XCTAssert(tuple.1.unwrap().as.int.value == 404)

        let tupleWithPropertyName = mock.tupleWithPropertyName
        value.tupleWithPropertyName = ("fail", 404)

        XCTAssert(tupleWithPropertyName.status.unwrap().as.string.value == "fail")
        XCTAssert(tupleWithPropertyName.code.unwrap().as.int.value == 404)

        let tupleOrNil = mock.tupleOrNil
        value.tupleOrNil = ("fail", nil)

        XCTAssert(tupleOrNil.status.unwrap().as.string.value == "fail")
        XCTAssert(tupleOrNil.code.unwrap().value == nil)

        let dictionary = mock.dictionary
        value.dictionary["key"] = ""
        XCTAssert(dictionary.key.unwrap().value == nil)

        let dictionaryOrNil = mock.dictionaryOrNil
        value.dictionaryOrNil?["nil"] = "value"
        XCTAssert(dictionaryOrNil.nil.unwrap().as.string.value == "value")

        let nsDictionary = mock.nsDictionary
        XCTAssert(nsDictionary.key.unwrap().as.string.value == "value")
        
        let nsDictionaryOrNil = mock.nsDictionaryOrNil
        XCTAssert(nsDictionaryOrNil.null.unwrap().value == nil)

        let nsMutableDictionary = mock.nsMutableDictionary
        nsMutableDictionary.unwrap().as.nsMutableDictionary().success { (dic) in
            XCTAssert(dic.count == 1)
            dic.removeAllObjects()
        }
        XCTAssert(nsMutableDictionary.unwrap().value == nil)

        let array = mock.array
        XCTAssert(array[0].unwrap().as.int.value == 500)

        let arrayOrNil = mock.arrayOrNil
        XCTAssert(arrayOrNil[0].unwrap().value == nil)

        let nsArray = mock.nsArray
        XCTAssert(nsArray[0].unwrap().as.int.value == 500)

        let nsArrayOrNil = mock.nsArrayOrNil
        XCTAssert(nsArrayOrNil[0].unwrap().value == nil)

        let nsMutableArray = mock.nsMutableArray
        nsMutableArray.unwrap().as.nsMutableArray().success { (arr) in
            XCTAssert(arr.count == 3)
            arr.removeAllObjects()
        }
        XCTAssert(nsMutableArray.unwrap().value == nil)

        let set = mock.set
        XCTAssert(set.unwrap().as.set(AnyHashable.self).value?.count == 3)

        let setOrNil = mock.setOrNil
        XCTAssert(setOrNil.unwrap().as.set(AnyHashable.self, predicate: .exception).value?.count == 2)

        let nsSet = mock.nsSet
        XCTAssert(nsSet.unwrap().as.nsSet().value?.count == 3)

        let nsSetOrNil = mock.nsSetOrNil
        XCTAssert(nsSetOrNil.unwrap().as.nsSet(predicate: .exception).value?.count == 2)

        let nsMutableSet = mock.nsMutableSet
        nsMutableSet.unwrap().as.nsMutableSet().success { (set) in
            XCTAssert(set.count == 3)
            set.removeAllObjects()
        }
        XCTAssert(nsMutableSet.unwrap().value == nil)

    }
    
    func testText() {
        
//        let mock = Mock()
//
//        let reference = Jsonful.reference(mock)
//        let snapshot = Jsonful.snapshot(mock)
//
//        mock.string = "fail"
//        XCTAssert(snapshot.string.unwrap().as.string.value == "success")
//        XCTAssert(reference.string.unwrap().as.string.value == "fail")
//
//        mock.nsString = ""
//        XCTAssert(snapshot.nsString.unwrap().as.nsString.value == "success")
//        XCTAssert(reference.nsString.unwrap().as.nsString.value == nil)
//
//        mock.nsMutableString.append("200")
//        snapshot.nsMutableString.unwrap().as.nsMutableString.success { (value) in
//            XCTAssert(value == "success")
//            value.deleteCharacters(in: .init(location: 0, length: value.length))
//            XCTAssert(mock.nsMutableString == "success200")
//        }
//
//        reference.nsMutableString.unwrap().as.nsMutableString.success { (value) in
//            XCTAssert(value == "success200")
//            value.deleteCharacters(in: .init(location: 0, length: value.length))
//            XCTAssert(mock.nsMutableString == "")
//        }
        
    }
    
}
