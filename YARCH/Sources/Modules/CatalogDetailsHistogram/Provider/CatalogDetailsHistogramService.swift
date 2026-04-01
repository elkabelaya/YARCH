//
//  Created by elkabelaya on 01/04/2026.
//

import Foundation

protocol CatalogDetailsHistogramServiceProtocol {
    func fetchItem(
        coinSym: String,
        completion: @escaping ([CatalogDetailsHistogramItemModel]?,
                               CatalogDetailsHistogramServiceError?) -> Void
    )
}

enum CatalogDetailsHistogramServiceError: Error {
    case getItemsFailed(message: String)
    case unknown

    var localizedDescription: String {
        switch self {
        case .getItemsFailed(message: let message):
            return message
        case .unknown:
            return "Unknown error"
        }
    }
}

/// Получает данные для модуля CatalogDetailsHistogram
class CatalogDetailsHistogramService: CatalogDetailsHistogramServiceProtocol {
    let apiClient: APIClient
    let decoder: JSONDecoder

    init(apiClient: APIClient = APIClientProvider.shared.client(type: .cryptocompareMin),
         decoder: JSONDecoder = JSONDecoder()) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func fetchItem(
        coinSym: String,
        completion: @escaping ([CatalogDetailsHistogramItemModel]?,
                               CatalogDetailsHistogramServiceError?) -> Void
    ) {
        apiClient.get(endPoint: "histominute",
                      parameters: ["aggregate": "1",
                                   "e": "CCCAGG",
                                   "fsym": coinSym,
                                   "limit": "100",
                                   "tryConversion": "false",
                                   "tsym": "USDT"
                                  ]
        ) { (result: Result<Data>) in
            switch result {
            case let .success(data):
               let model = self.parseSuccessData(data: data)
                if let data = model?.data {
                    completion(data, nil)
                } else {
                    if let message = model?.message {
                        completion(nil, CatalogDetailsHistogramServiceError.getItemsFailed(message: message))
                    } else {
                        completion(nil, CatalogDetailsHistogramServiceError.unknown)
                    }
                }
            case .failure:
                completion(nil, CatalogDetailsHistogramServiceError.unknown)
            }
        }
    }

    private func parseSuccessData(data: Data) -> CatalogDetailsHistogramResponseModel? {
        do {
            let response = try decoder.decode(CatalogDetailsHistogramResponseModel.self, from: data)
            return response
        } catch {
            return nil
        }
    }
}
