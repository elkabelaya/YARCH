//
//  CatalogDetailsHistogram module
//  Created by elkabelaya on 01/04/2026.
//

protocol CatalogDetailsHistogramBusinessLogic {
    func fetchHistory(request: CatalogDetailsHistogram.ShowHistogram.Request)
}

/// Класс для описания бизнес-логики модуля CatalogDetailsHistogram
class CatalogDetailsHistogramInteractor: CatalogDetailsHistogramBusinessLogic {
    let presenter: CatalogDetailsHistogramPresentationLogic
    let provider: CatalogDetailsHistogramProviderProtocol

    init(presenter: CatalogDetailsHistogramPresentationLogic, provider: CatalogDetailsHistogramProviderProtocol = CatalogDetailsHistogramProvider()) {
        self.presenter = presenter
        self.provider = provider
    }

    // MARK: Do something
    func fetchHistory(request: CatalogDetailsHistogram.ShowHistogram.Request) {
        provider.getItem(coinSym: request.coinSym) { (items, error) in
            let result: CatalogDetailsHistogram.CatalogDetailsHistogramRequestResult
            if let items = items {
                result = .success(items)
            } else if let error = error {
                result = .failure(.someError(message: error.localizedDescription))
            } else {
                result = .failure(.someError(message: "No Data"))
            }
            self.presenter.presentHistory(response: CatalogDetailsHistogram.ShowHistogram.Response(result: result))
        }
    }
}
