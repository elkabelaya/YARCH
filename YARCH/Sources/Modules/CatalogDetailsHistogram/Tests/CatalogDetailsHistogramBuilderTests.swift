//
//  SUT: CatalogDetailsHistogramBuilder
//
//  Collaborators:
//  CatalogDetailsHistogramViewController
//  CatalogDetailsHistogramInteractor
//  CatalogDetailsHistogramPresenter
//  CatalogDetailsHistogramProvider
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsHistogramBuilderTests: QuickSpec {
    override class func spec() {
        var builder: CatalogDetailsHistogramBuilder!

        beforeEach {
            builder = CatalogDetailsHistogramBuilder()
        }

        describe(".build") {
            it("should build module parts") {
                // when
                let controller = builder.set(initialState: TestData.initialState).build() as? CatalogDetailsHistogramViewController
                let interactor = controller?.interactor as? CatalogDetailsHistogramInteractor
                let presenter = interactor?.presenter as? CatalogDetailsHistogramPresenter

                // then
                expect(controller).toNot(beNil())
                expect(interactor).toNot(beNil())
                expect(presenter).toNot(beNil())
            }

            it("should set dependencies between module parts") {
                // when
                let controller = builder.set(initialState: TestData.initialState).build() as? CatalogDetailsHistogramViewController
                let interactor = controller?.interactor as? CatalogDetailsHistogramInteractor
                let presenter = interactor?.presenter as? CatalogDetailsHistogramPresenter

                // then
                expect(presenter?.viewController).to(beIdenticalTo(controller))
            }
        }
    }
}

extension CatalogDetailsHistogramBuilderTests {
    enum TestData {
        static let initialState = CatalogDetailsHistogram.ViewControllerState.loading
    }
}
