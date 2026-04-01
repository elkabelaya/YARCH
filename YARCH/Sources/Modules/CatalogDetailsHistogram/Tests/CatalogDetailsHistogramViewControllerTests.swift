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
    override func spec() {
        var viewController: CatalogDetailsHistogramViewController!
        var interactorMock: CatalogDetailsHistogramInteractorMock!

        beforeEach {
            interactorMock = CatalogDetailsHistogramInteractorMock()
            viewController = CatalogDetailsHistogramViewController(interactor: interactorMock)
        }

        describe(".doSomething") {
            it("should call method in interactor") {
                // when
                viewController.doSomething()

                // then
                expect(interactorMock.doSomethingWasCalled).to(equal(1))
                expect(interactorMock.doSomethingArguments).toNot(beNil())
            }
        }
    }
}

extension CatalogDetailsHistogramViewControllerTests {
    enum TestData {
        static let request = CatalogDetailsHistogram.Something.Request()
    }
}

private class CatalogDetailsHistogramInteractorMock: CatalogDetailsHistogramBusinessLogic {
    var doSomethingWasCalled: Int = 0
    var doSomethingArguments: CatalogDetailsHistogram.Something.Request?

    func doSomething(request: CatalogDetailsHistogram.Something.Request) {
        doSomethingWasCalled += 1
        doSomethingArguments = request
    }
}
