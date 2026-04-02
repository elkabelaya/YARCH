//
//  SUT: CatalogDetailsHistogramInteractor
//
//  Collaborators:
//  CatalogDetailsHistogramProvider
//  CatalogDetailsHistogramPresenter
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsHistogramInteractorTests: QuickSpec {
    override class func spec() {
        var interactor: CatalogDetailsHistogramInteractor!
        var presenterMock: CatalogDetailsHistogramPresenterMock!
        var providerMock: CatalogDetailsHistogramProviderMock!

        beforeEach {
            providerMock = CatalogDetailsHistogramProviderMock()
            presenterMock = CatalogDetailsHistogramPresenterMock()
            interactor = CatalogDetailsHistogramInteractor(presenter: presenterMock, provider: providerMock)
        }

        describe(".fetchHistory") {
            it("should get data from provider") {
                // when
                interactor.fetchHistory(request: TestData.request)
                // then
                expect(providerMock.getItemsWasCalled).to(equal(1))
            }

            context("getItems successfull") {
                it("should prepare success response and call presenter") {
                    // given
                    providerMock.getItemsCompletionStub = (result: TestData.models, error: nil)
                    // when
                    interactor.fetchHistory(request: TestData.request)
                    // then
                    expect(presenterMock.presentSomethingWasCalled).to(equal(1))
                    expect(presenterMock.presentSomethingArguments).toNot(beNil())
                    expect { if case .success(_)? = presenterMock.presentSomethingArguments?.result { return true }; return false }.to(beTrue())
                }
            }

            context("getItems failed") {
                it("should prepare failed response and call presenter") {
                    // given
                    providerMock.getItemsCompletionStub = (result: nil, error: TestData.getItemsFailedError)
                    // when
                    interactor.fetchHistory(request: TestData.request)
                    // then
                    expect(presenterMock.presentSomethingWasCalled).to(equal(1))
                    expect(presenterMock.presentSomethingArguments).toNot(beNil())
                    expect { if case .failure(_)? = presenterMock.presentSomethingArguments?.result { return true }; return false }.to(beTrue())
                }
            }
        }
    }
}

extension CatalogDetailsHistogramInteractorTests {
    enum TestData {
        static let coinSym = "BTC"
        static let request = CatalogDetailsHistogram.ShowHistogram.Request(coinSym: coinSym)
        static let models = CatalogDetailsHistogramItemModelTests.TestData.entitiesCollection()

        fileprivate static let underlyingError = ErrorMock()
        fileprivate static let getItemsFailedError = CatalogDetailsHistogramProviderError.getItemsFailed(
            underlyingError: .getItemsFailed(message: "error")
        )
    }
}

private class CatalogDetailsHistogramProviderMock: CatalogDetailsHistogramProviderProtocol {
    var getItemsWasCalled: Int = 0
    var getItemsArguments: (([CatalogDetailsHistogramItemModel]?, CatalogDetailsHistogramProviderError?) -> Void)?
    var getItemsCompletionStub: (result: [CatalogDetailsHistogramItemModel]?, error: CatalogDetailsHistogramProviderError?) = (nil, nil)

    func getItem(coinSym: String, completion: @escaping ([CatalogDetailsHistogramItemModel]?, CatalogDetailsHistogramProviderError?) -> Void) {
        getItemsWasCalled += 1
        getItemsArguments = completion
        completion(getItemsCompletionStub.result, getItemsCompletionStub.error)
    }
}

private class CatalogDetailsHistogramPresenterMock: CatalogDetailsHistogramPresentationLogic {

    var presentSomethingWasCalled: Int = 0
    var presentSomethingArguments: CatalogDetailsHistogram.ShowHistogram.Response?

    func presentHistory(response: YARCH.CatalogDetailsHistogram.ShowHistogram.Response) {
        presentSomethingWasCalled += 1
        presentSomethingArguments = response
    }
}

private class ErrorMock: Error { }
