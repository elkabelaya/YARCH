//
//  Created by elkabelaya on 01/04/2026.
//

import Foundation

protocol CatalogDetailsHistogramProviderProtocol {
    func getItem(coinSym: String, completion: @escaping ([CatalogDetailsHistogramItemModel]?, CatalogDetailsHistogramProviderError?) -> Void)
}

enum CatalogDetailsHistogramProviderError: Error {
    case getItemsFailed(underlyingError: CatalogDetailsHistogramServiceError)
    case unknown

    var localizedDescription: String {
        switch self {
        case .getItemsFailed(underlyingError: let error):
            return error.localizedDescription
            case .unknown:
            return "Unknown error"
        }
    }
}

extension CatalogDetailsHistogramProviderError: LocalizedError { }

/// Отвечает за получение данных модуля CatalogDetailsHistogram
struct CatalogDetailsHistogramProvider: CatalogDetailsHistogramProviderProtocol {
    let dataStore: CatalogDetailsHistogramDataStore
    let service: CatalogDetailsHistogramServiceProtocol

    init(dataStore: CatalogDetailsHistogramDataStore = CatalogDetailsHistogramDataStore(), service: CatalogDetailsHistogramServiceProtocol = CatalogDetailsHistogramService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func getItem(coinSym: String, completion: @escaping ([CatalogDetailsHistogramItemModel]?, CatalogDetailsHistogramProviderError?) -> Void) {
        if let model = dataStore.models[coinSym] {
            return completion(model, nil)
        }
        service.fetchItem(coinSym: coinSym) { (result, error) in
            if let model = result {
                self.dataStore.models[coinSym] = model
                completion(model, nil)
            } else if let error {
                completion(nil, .getItemsFailed(underlyingError: error))
            } else {
                completion(nil, .unknown)
            }
        }
    }
}
