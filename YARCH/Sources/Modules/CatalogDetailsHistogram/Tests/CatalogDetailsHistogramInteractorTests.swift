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
    override func spec() {
        var interactor: CatalogDetailsHistogramInteractor!
        var presenterMock: CatalogDetailsHistogramPresenterMock!
        var providerMock: CatalogDetailsHistogramProviderMock!

        beforeEach {
            providerMock = CatalogDetailsHistogramProviderMock()
            presenterMock = CatalogDetailsHistogramPresenterMock()
            interactor = CatalogDetailsHistogramInteractor(presenter: presenterMock, provider: providerMock)
        }

        describe(".doSomething") {
            it("should get data from provider") {
                // when
                interactor.doSomething(request: TestData.request)
                // then
                expect(providerMock.getItemsWasCalled).to(equal(1))
            }

            context("getItems successfull") {
                it("should prepare success response and call presenter") {
                    // given
                    providerMock.getItemsCompletionStub = (result: TestData.models, error: nil)
                    // when
                    interactor.doSomething(request: TestData.request)
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
                    interactor.doSomething(request: TestData.request)
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
        static let request = CatalogDetailsHistogram.Something.Request()
        static let models = CatalogDetailsHistogramModelTests.TestData.entitiesCollection()

        fileprivate static let underlyingError = ErrorMock()
        fileprivate static let getItemsFailedError = CatalogDetailsHistogramProviderError.getItemsFailed(underlyingError: underlyingError)
    }
}

private class CatalogDetailsHistogramProviderMock: CatalogDetailsHistogramProviderProtocol {
    var getItemsWasCalled: Int = 0
    var getItemsArguments: (([CatalogDetailsHistogramModel]?, CatalogDetailsHistogramProviderError?) -> Void)?
    var getItemsCompletionStub: (result: [CatalogDetailsHistogramModel]?, error: CatalogDetailsHistogramProviderError?) = (nil, nil)

    func getItems(completion: @escaping ([CatalogDetailsHistogramModel]?, CatalogDetailsHistogramProviderError?) -> Void) {
        getItemsWasCalled += 1
        getItemsArguments = completion
        completion(getItemsCompletionStub.result, getItemsCompletionStub.error)
    }
}

private class CatalogDetailsHistogramPresenterMock: CatalogDetailsHistogramPresentationLogic {
    var presentSomethingWasCalled: Int = 0
    var presentSomethingArguments: CatalogDetailsHistogram.Something.Response?

    func presentSomething(response: CatalogDetailsHistogram.Something.Response) {
        presentSomethingWasCalled += 1
        presentSomethingArguments = response
    }
}

private class ErrorMock: Error { }
