//
//  SUT: CatalogDetailsHistogramProvider
//
//  Collaborators:
//  CatalogDetailsHistogramService
//  CatalogDetailsHistogramDataStore
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsHistogramProviderTests: QuickSpec {
    override class func spec() {
        var provider: CatalogDetailsHistogramProvider!
        var serviceMock: CatalogDetailsHistogramServiceMock!
        var dataStoreMock: CatalogDetailsHistogramDataStoreMock!

        var getItemsResult: (items: [CatalogDetailsHistogramItemModel]?, error: CatalogDetailsHistogramProviderError?)

        beforeEach {
            serviceMock = CatalogDetailsHistogramServiceMock()
            dataStoreMock = CatalogDetailsHistogramDataStoreMock()
            provider = CatalogDetailsHistogramProvider(dataStore: dataStoreMock, service: serviceMock)

            getItemsResult = (nil, nil)
        }

        describe(".getItems") {
            context("cache is empty") {
                beforeEach {
                    dataStoreMock.models = [:]
                }

                it("should request data from service") {
                    // when
                    provider.getItem(coinSym: TestData.symbol) { (_, _) in }
                    // then
                    expect(serviceMock.fetchItemsWasCalled).to(equal(1))
                }

                context("successfull response") {
                    it("should save data to store") {
                        // given
                        serviceMock.fetchItemsCompletionStub = (TestData.responseData, nil)
                        // when
                        provider.getItem(coinSym: TestData.symbol) { (_, _) in }
                        // then
                        expect(dataStoreMock.models[TestData.symbol]).to(equal(TestData.responseData))
                    }

                    it("should return result in callback") {
                        // given
                        serviceMock.fetchItemsCompletionStub = (TestData.responseData, nil)
                        // when
                        provider.getItem(coinSym: TestData.symbol) { getItemsResult = ($0, $1) }
                        // then
                        expect(getItemsResult.items).to(equal(TestData.responseData))
                        expect(getItemsResult.error).to(beNil())
                    }
                }

                context("failed response") {
                    it("should not update store") {
                        // given
                        serviceMock.fetchItemsCompletionStub = (nil, TestData.responseError)
                        // when
                        provider.getItem(coinSym: TestData.symbol) { (_, _) in }
                        // then
                        expect(dataStoreMock.models).to(beEmpty())
                    }

                    it("should return error in callback") {
                        // given
                        serviceMock.fetchItemsCompletionStub = (nil, TestData.responseError)
                        // when
                        provider.getItem(coinSym: TestData.symbol) { getItemsResult = ($0, $1) }
                        // then
                        expect(getItemsResult.items).to(beNil())
                        expect { if case .getItemsFailed(_)? = getItemsResult.error { return true }; return false }.to(beTrue())
                    }
                }
            }
        }

        context("cache fulfilled") {
            it("should not call service") {
                // given
                dataStoreMock.models[TestData.symbol] = TestData.responseData
                // when
                provider.getItem(coinSym: TestData.symbol) { (_, _) in }
                // then
                expect(serviceMock.fetchItemsWasCalled).to(equal(0))
            }

            it("should return data in callback") {
                // given
                dataStoreMock.models[TestData.symbol] = TestData.responseData
                // when
                provider.getItem(coinSym: TestData.symbol) { getItemsResult = ($0, $1) }
                // then
                expect(getItemsResult.items).to(equal(TestData.responseData))
                expect(getItemsResult.error).to(beNil())
            }
        }
    }
}

extension CatalogDetailsHistogramProviderTests {
    enum TestData {
        static let symbol: String = "BTC"
        static let responseData = CatalogDetailsHistogramItemModelTests.TestData.entitiesCollection()
        static let responseError = CatalogDetailsHistogramServiceError.getItemsFailed(message: "failed")
    }
}

private class CatalogDetailsHistogramServiceMock: CatalogDetailsHistogramServiceProtocol {

    var fetchItemsWasCalled: Int = 0
    var fetchItemsArguments: (([CatalogDetailsHistogramItemModel]?, CatalogDetailsHistogramServiceError?) -> Void)?
    var fetchItemsCompletionStub: (result: [CatalogDetailsHistogramItemModel]?, error: CatalogDetailsHistogramServiceError?)

    func fetchItem(coinSym: String, completion: @escaping ([CatalogDetailsHistogramItemModel]?, CatalogDetailsHistogramServiceError?) -> Void) {
        fetchItemsWasCalled += 1
        fetchItemsArguments = completion
        completion(fetchItemsCompletionStub.result, fetchItemsCompletionStub.error)
    }
}

private class CatalogDetailsHistogramDataStoreMock: CatalogDetailsHistogramDataStore {

}

private class ErrorMock: Error {}

enum APIClientError: Error {
    case other
}
