//
//  CatalogDetailsHistogram module
//  Created by elkabelaya on 01/04/2026.
//

import UIKit

protocol CatalogDetailsHistogramPresentationLogic {
    func presentHistory(response: CatalogDetailsHistogram.ShowHistogram.Response)
}

/// Отвечает за отображение данных модуля CatalogDetailsHistogram
final class CatalogDetailsHistogramPresenter: CatalogDetailsHistogramPresentationLogic {
    weak var viewController: CatalogDetailsHistogramDisplayLogic?

    // MARK: Do something
    func presentHistory(response: CatalogDetailsHistogram.ShowHistogram.Response) {
        var viewModel: CatalogDetailsHistogram.ShowHistogram.ViewModel

        switch response.result {
        case let .failure(error):
            switch error {
            case .someError(let message):
                viewModel = CatalogDetailsHistogram.ShowHistogram.ViewModel(state: .error(message: message))
            }

        case let .success(result):
            if result.isEmpty {
                viewModel = CatalogDetailsHistogram.ShowHistogram.ViewModel(state: .emptyResult)
            } else {
                viewModel = CatalogDetailsHistogram.ShowHistogram.ViewModel(
                    state: .result(makeHistogramViewModel(result))
                )
            }
        }

        viewController?.displayHistory(viewModel: viewModel)
    }

    private func makeHistogramViewModel(_ model: [CatalogDetailsHistogramItemModel]) -> CatalogDetailsHistogramViewModel {
        var (min, max): (Double?, Double?) = model.reduce(into: (nil, nil)) {partialResult, current in
            if let result = partialResult.0 {
                if current.low < result {
                    partialResult.0 = current.low
                }
            } else {
                partialResult.0 = current.low
            }

            if let result = partialResult.1 {
                if current.high > result {
                    partialResult.1 = current.high
                }
            } else {
                partialResult.1 = current.high
            }
            print(current)
        }

        min = min ?? 0
        max = max ?? 0
        let padding = (max! - min!)*0.5

        return CatalogDetailsHistogramViewModel(
            title: "test",
            image: nil,
            data: model.map {item in
                CatalogDetailsHistogramItemViewModel(
                    id: UUID().uuidString,
                    date: Date(timeIntervalSince1970: TimeInterval(item.time)),
                    close: item.close,
                    high: item.high,
                    low: item.low,
                    open: item.open
                )
            },
            min: (min ?? 0) - padding,
            max: (max ?? 0) + padding
        )
    }
}
