//
//  SUT: CatalogDetailsHistogramModel
//

import Quick
import Nimble

@testable import YARCH

 class CatalogDetailsHistogramItemModelTests: QuickSpec {
    override class func spec() {
        describe("equalit operator") {
            it("should return true for same objects") {
                expect(TestData.model == TestData.model).to(beTrue())
            }

            it("should return false for objects with different time") {
                expect(TestData.model == TestData.differentTimeModel).to(beFalse())
            }

            it("should ignore close attribute for equality") {
                expect(TestData.model == TestData.differentCloseModel).to(beTrue())
            }
        }
    }
 }

 extension CatalogDetailsHistogramItemModelTests {
    enum TestData {
        static let uid = UUID().uuidString
        static let name = "Name"
        static let model = CatalogDetailsHistogramItemModel(
            time: Int(Date().timeIntervalSince1970),
            close: 6,
            high: 10,
            low: 5,
            open: 7,
            volumeFrom: 10,
            volumeTo: 20,
            conversionType: "",
            conversionSymbol: ""
        )
        static let differentCloseModel = model.copy(close: model.close-1)
        static let differentTimeModel = model.copy(time: 12)

        static let defaultEntitiesCollectionCount = 1
        static func entitiesCollection(withCount count: Int = defaultEntitiesCollectionCount) -> [CatalogDetailsHistogramItemModel] {
            var collection: [CatalogDetailsHistogramItemModel] = []
//            while collection.count < count {
//                collection.append(CatalogDetailsHistogramItemModel(uid: UUID().uuidString, name: "name"))
//            }
            return collection
        }
    }
 }

 fileprivate extension CatalogDetailsHistogramItemModel {
    func copy(
        time: Int? = nil,
        close: Double? = nil,
        high: Double? = nil,
        low: Double? = nil,
        open: Double? = nil,
        volumeFrom: Double? = nil,
        volumeTo: Double? = nil,
        conversionType: String? = nil,
        conversionSymbol: String? = nil
    ) -> CatalogDetailsHistogramItemModel {
        return CatalogDetailsHistogramItemModel(
            time: time ??  self.time,
            close: close ??  self.close,
            high: high ??  self.high,
            low: low ??  self.low,
            open: open ??  self.open,
            volumeFrom: volumeFrom ??  self.volumeFrom,
            volumeTo: volumeTo ??  self.volumeTo,
            conversionType: conversionType ??  self.conversionType,
            conversionSymbol: conversionSymbol ??  self.conversionSymbol
            )
    }
 }
