//
//  CatalogDetailsHistogram module
//  Created by elkabelaya on 01/04/2026.
//

enum CatalogDetailsHistogram {
    // MARK: Use cases
    enum ShowHistogram {
        struct Request {
            let coinSym: String
        }

        struct Response {
            var result: CatalogDetailsHistogramRequestResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }

    enum CatalogDetailsHistogramRequestResult {
        case failure(CatalogDetailsHistogramError)
        case success([CatalogDetailsHistogramItemModel])
    }

    enum ViewControllerState {
        case initial(model: CoinSnapshotFullViewModel)
        case loading
        case result(CatalogDetailsHistogramViewModel)
        case emptyResult
        case error(message: String)
    }

    enum CatalogDetailsHistogramError: Error {
        case someError(message: String)
    }
}
