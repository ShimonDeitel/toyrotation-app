import XCTest
@testable import ToyRotationTracker

@MainActor
final class ToyRotationTrackerTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testAddItem() {
        let item = Toy(toyName: "Test", status: "Note")
        store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddInsertsAtFront() {
        store.add(Toy(toyName: "First", status: ""))
        store.add(Toy(toyName: "Second", status: ""))
        XCTAssertEqual(store.items.first?.toyName, "Second")
    }

    func testDeleteItem() {
        let item = Toy(toyName: "ToDelete", status: "")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testDeleteAtOffsets() {
        store.add(Toy(toyName: "A", status: ""))
        store.add(Toy(toyName: "B", status: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitAllowsAdding() {
        for i in 0..<Store.freeLimit {
            store.add(Toy(toyName: "Item \(i)", status: ""))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.add(Toy(toyName: "One", status: ""))
        XCTAssertTrue(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Toy(toyName: "Item \(i)", status: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateItem() {
        var item = Toy(toyName: "Original", status: "")
        store.add(item)
        item.toyName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.toyName, "Updated")
    }
}
