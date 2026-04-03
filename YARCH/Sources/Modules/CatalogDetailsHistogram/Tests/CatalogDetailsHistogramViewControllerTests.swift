//
//  SUT: CatalogDetailsHistogramViewController
//
//  Collaborators:
//  CatalogDetailsHistogramInteractor
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsHistogramViewControllerTests: QuickSpec {
    override class func spec() {
        var viewController: CatalogDetailsHistogramViewController!
        var interactorMock: CatalogDetailsHistogramInteractorMock!

        beforeEach {
            interactorMock = CatalogDetailsHistogramInteractorMock()
            viewController = CatalogDetailsHistogramViewController(
                interactor: interactorMock,
                initialState: .initial(model: TestData.model)
            )
        }

        describe(".fetchHistogramInfo") {
            it("should call method fetchHistory in interactor") {
                // when
                viewController.fetchHistogramInfo(coinSym: TestData.symbol )

                // then
                expect(interactorMock.doSomethingWasCalled).to(equal(1))
                expect(interactorMock.doSomethingArguments).toNot(beNil())
            }
        }
    }
}

extension CatalogDetailsHistogramViewControllerTests {
    enum TestData {
        static let coinId = "1"
        static let uid = UUID().uuidString
        static let symbol = "SOME"
        static let title = "SomeCoin"
        static let otherTitle = "OtherCoin"
        static let imageUrlString = "http://www.example.com/image.png"
        static let website = "http://www.example.com"
        static let twitter = "http://www.twitter.com/jack"
        static let totalSupply = 10000000.0
        static let totalMined = 80.0
        static let blockReward = 12.0
        static let twitterModel = TwitterModel(url: twitter)
        static let model = CoinSnapshotFullViewModel(
            uid: uid,
            symbol: symbol,
            title: title,
            image: nil,
            properties: []
        )
        static let request = CatalogDetailsHistogram.ShowHistogram.Request(coinSym: "EXT")
    }
}

private class CatalogDetailsHistogramInteractorMock: CatalogDetailsHistogramBusinessLogic {
    func fetchHistory(request: YARCH.CatalogDetailsHistogram.ShowHistogram.Request) {
        doSomethingWasCalled += 1
        doSomethingArguments = request
    }

    var doSomethingWasCalled: Int = 0
    var doSomethingArguments: CatalogDetailsHistogram.ShowHistogram.Request?
}
