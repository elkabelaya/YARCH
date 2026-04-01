//
//  CatalogDetailsHistogram module
//  Created by elkabelaya on 01/04/2026.
//

import UIKit

protocol CatalogDetailsHistogramDisplayLogic: class {
    func displayHistory(viewModel: CatalogDetailsHistogram.ShowHistogram.ViewModel)
}

class CatalogDetailsHistogramViewController: UIViewController {
    let interactor: CatalogDetailsHistogramBusinessLogic
    var state: CatalogDetailsHistogram.ViewControllerState!

    var customView: CatalogDetailsHistogramView? {
        return view as? CatalogDetailsHistogramView
    }

    init(interactor: CatalogDetailsHistogramBusinessLogic, initialState: CatalogDetailsHistogram.ViewControllerState) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle
    override func loadView() {
        let view = CatalogDetailsHistogramView(frame: UIScreen.main.bounds,
                                               refreshDelegate: self)
        self.view = view
        // make additional setup of view or save references to subviews
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        display(newState: .loading)
    }

    // MARK: State Updates

    func applyLoadingState(model: CoinSnapshotFullViewModel) {
        title = model.title
        customView?.showLoading()
        fetchHistogramInfo(coinSym: model.symbol)
    }

    func applyErrorState(message: String) {
        customView?.showError(message: message)
    }

    func applyResult(viewModel: CatalogDetailsHistogramViewModel) {
        customView?.showChart()
        customView?.updateData(model: viewModel)
    }

    // MARK: Fetch Coin Detail Information

    func fetchHistogramInfo(coinSym: String) {
        let request = CatalogDetailsHistogram.ShowHistogram.Request(coinSym: coinSym)
        interactor.fetchHistory(request: request)
    }
}

extension CatalogDetailsHistogramViewController: CatalogDetailsHistogramDisplayLogic {
    func displayHistory(viewModel: CatalogDetailsHistogram.ShowHistogram.ViewModel) {
        display(newState: viewModel.state)
    }

    func display(newState: CatalogDetailsHistogram.ViewControllerState) {
        switch (state, newState) {
        case (.initial(let model), .loading):
            applyLoadingState(model: model)
        case let (_, .error(message)):
            applyErrorState(message: message)
        case let (_, .result(item)):
            applyResult(viewModel: item)
        case let (_, .emptyResult):
            applyErrorState(message: "No data to show")
        default:
            break
        }
        state = newState
    }
}

extension CatalogDetailsHistogramViewController: CatalogErrorViewDelegate {
    func reloadButtonWasTapped() {
        display(newState: .loading)
    }
}
