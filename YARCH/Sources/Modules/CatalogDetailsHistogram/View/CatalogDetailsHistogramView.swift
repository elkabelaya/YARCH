//
//  Created by elkabelaya on 01/04/2026.
//

import UIKit

extension CatalogDetailsHistogramView {
    struct Appearance {
        let backgroundColor: UIColor = .white
    }
}

class CatalogDetailsHistogramView: UIView {
    let appearance = Appearance()
    weak var refreshActionsDelegate: CatalogErrorViewDelegate?

    var chartView: UIView?

    let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    lazy var errorView: CatalogErrorView = {
        let view = CatalogErrorView()
        view.delegate = self.refreshActionsDelegate
        return view
    }()

    init(frame: CGRect = CGRect.zero,
                  refreshDelegate: CatalogErrorViewDelegate) {
        super.init(frame: frame)
        self.refreshActionsDelegate = refreshDelegate
        setup()
        addSubviews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = self.appearance.backgroundColor
    }
    private func addSubviews() {
        addSubview(loadingView)
        addSubview(errorView)
    }

    private func makeConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func lineChartView(data: CatalogDetailsHistogramViewModel) -> UIView {
        let view = LineChartView(data: data).toUIView()
        return view
    }

    func showLoading() {
        show(view: loadingView)
        loadingView.startAnimating()
    }

    func showError(message: String) {
        show(view: errorView)
        errorView.title.text = message
    }

    func showChart() {
        if let chartView {
            show(view: chartView)
        }
    }

    func show(view: UIView) {
        subviews.forEach { $0.isHidden = (view != $0) }
    }

    func updateData(model: CatalogDetailsHistogramViewModel) {
        chartView = lineChartView(data: model)
        if let chartView {
            addSubview(chartView)
            chartView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
