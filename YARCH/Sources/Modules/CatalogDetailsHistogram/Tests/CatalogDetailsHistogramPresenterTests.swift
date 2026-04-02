//
//  SUT: CatalogDetailsHistogramPresenter
//
//  Collaborators:
//  CatalogDetailsHistogramViewController
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsHistogramPresenterTests: QuickSpec {
    override class func spec() {
        var presenter: CatalogDetailsHistogramPresenter!
        var viewControllerMock: CatalogDetailsHistogramViewControllerMock!

        beforeEach {
            presenter = CatalogDetailsHistogramPresenter()
            viewControllerMock = CatalogDetailsHistogramViewControllerMock()
            presenter.viewController = viewControllerMock
        }

        describe(".presentSomething") {
            context("successfull empty result") {
                it("should prepare empty view model and display it in view") {
                    // when
                    presenter.presentHistory(response: TestData.successEmptyResponse)
                    // then
                    expect(viewControllerMock.displaySomethingWasCalled).to(beTruthy())
                    expect { if case .emptyResult? = viewControllerMock.displaySomethingArguments?.state { return true }; return false }.to(beTrue())
                }
            }

            context("successfull result") {
                it("should prepare result view model and display it in view") {
                    // when
                    presenter.presentHistory(response: TestData.successResponse)
                    // then
                    expect(viewControllerMock.displaySomethingWasCalled).to(beTruthy())
                    expect { if case .result(_)? = viewControllerMock.displaySomethingArguments?.state { return true }; return false }.to(beTrue())
                }
            }

            context("failure result") {
                it("should prepare error view model and display it in view") {
                    // when
                    presenter.presentHistory(response: TestData.failureResponse)
                    // then
                    expect(viewControllerMock.displaySomethingWasCalled).to(beTruthy())
                    expect { if case .error(_)? = viewControllerMock.displaySomethingArguments?.state { return true }; return false }.to(beTrue())
                }
            }
        }
    }
}

extension CatalogDetailsHistogramPresenterTests {
    enum TestData {
        static let successEmptyResponse = CatalogDetailsHistogram.ShowHistogram.Response(result: .success([]))
        static let successResponse = CatalogDetailsHistogram.ShowHistogram.Response(
            result: .success(
                [
                    CatalogDetailsHistogramItemModelTests.TestData.model
                ]
            )
        )
        static let failureResponse = CatalogDetailsHistogram.ShowHistogram.Response(result: .failure(.someError(message: "some error")))
    }
}

private class CatalogDetailsHistogramViewControllerMock: CatalogDetailsHistogramDisplayLogic {
    var displaySomethingWasCalled: Int = 0
    var displaySomethingArguments: CatalogDetailsHistogram.ShowHistogram.ViewModel?

    func displayHistory(viewModel: YARCH.CatalogDetailsHistogram.ShowHistogram.ViewModel) {
        displaySomethingWasCalled += 1
        displaySomethingArguments = viewModel
    }
}
