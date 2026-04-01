//
//  CatalogDetailsHistogram module
//  Created by elkabelaya on 01/04/2026.
//

import UIKit

class CatalogDetailsHistogramBuilder: ModuleBuilder {

    var initialState: CatalogDetailsHistogram.ViewControllerState?

    func set(initialState: CatalogDetailsHistogram.ViewControllerState) -> CatalogDetailsHistogramBuilder {
        self.initialState = initialState
        return self
    }

    func build() -> UIViewController {
        guard let initialState = initialState else {
            fatalError("Initial state parameter was not set")
        }

        let presenter = CatalogDetailsHistogramPresenter()
        let interactor = CatalogDetailsHistogramInteractor(presenter: presenter)
        let controller = CatalogDetailsHistogramViewController(
            interactor: interactor,
            initialState: initialState
        )

        presenter.viewController = controller
        return controller
    }
}
