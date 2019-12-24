import XCTest
import Jsonful


class Tests: XCTestCase {
    
    var mock: Mock!
    
    override func setUp() {
        super.setUp()
        self.mock = Mock()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSnapshot() {
        
        let mock = Jsonful.snapshot(self.mock)
        
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
        
        let mock = Jsonful.reference(self.mock)
        
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
        XCTAssert(nsMutableDictionary.unwrap().as.nsMutableDictionary().value != nil)
        
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
        XCTAssert(nsMutableArray.unwrap().as.nsMutableArray().value != nil)
        
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
        XCTAssert(nsMutableSet.unwrap().as.nsMutableSet().value != nil)
        
    }
    
}
