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
    override func spec() {
        var provider: CatalogDetailsHistogramProvider!
        var serviceMock: CatalogDetailsHistogramServiceMock!
        var dataStoreMock: CatalogDetailsHistogramDataStoreMock!

        var getItemsResult: (items: [CatalogDetailsHistogramModel]?, error: CatalogDetailsHistogramProviderError?)

        beforeEach {
            serviceMock = CatalogDetailsHistogramServiceMock()
            dataStoreMock = CatalogDetailsHistogramDataStoreMock()
            provider = CatalogDetailsHistogramProvider(dataStore: dataStoreMock, service: serviceMock)

            getItemsResult = (nil, nil)
        }

        describe(".getItems") {
            context("cache is empty") {
                beforeEach {
                    dataStoreMock.models = nil
                }

                it("should request data from service") {
                    // when
                    provider.getItems { (_, _) in }
                    // then
                    expect(serviceMock.fetchItemsWasCalled).to(equal(1))
                }

                context("successfull response") {
                    it("should save data to store") {
                        // given
                        serviceMock.fetchItemsCompletionStub = (TestData.responseData, nil)
                        // when
                        provider.getItems { (_, _) in }
                        // then
                        expect(dataStoreMock.models).to(equal(TestData.responseData))
                    }

                    it("should return result in callback") {
                        // given
                        serviceMock.fetchItemsCompletionStub = (TestData.responseData, nil)
                        // when
                        provider.getItems { getItemsResult = ($0, $1) }
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
                        provider.getItems { (_, _) in }
                        // then
                        expect(dataStoreMock.models).to(beNil())
                    }

                    it("should return error in callback") {
                        // given
                        serviceMock.fetchItemsCompletionStub = (nil, TestData.responseError)
                        // when
                        provider.getItems { getItemsResult = ($0, $1) }
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
                dataStoreMock.models = TestData.responseData
                // when
                provider.getItems { (_, _) in }
                // then
                expect(serviceMock.fetchItemsWasCalled).to(equal(0))
            }

            it("should return data in callback") {
                // given
                dataStoreMock.models = TestData.responseData
                // when
                provider.getItems { getItemsResult = ($0, $1) }
                // then
                expect(getItemsResult.items).to(equal(TestData.responseData))
                expect(getItemsResult.error).to(beNil())
            }
        }
    }
}

extension CatalogDetailsHistogramProviderTests {
    enum TestData {
        static let responseData = CatalogDetailsHistogramModelTests.TestData.entitiesCollection()
        static let responseError = APIClientError.other
    }
}

private class CatalogDetailsHistogramServiceMock: CatalogDetailsHistogramServiceProtocol {
    var fetchItemsWasCalled: Int = 0
    var fetchItemsArguments: (([CatalogDetailsHistogramModel]?, APIClientError?) -> Void)?
    var fetchItemsCompletionStub: (result: [CatalogDetailsHistogramModel]?, error: APIClientError?)

    func fetchItemfetchItem(coinSym: String, completion: @escaping ([CatalogDetailsHistogramModel]?, Error?) -> Void) {
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
