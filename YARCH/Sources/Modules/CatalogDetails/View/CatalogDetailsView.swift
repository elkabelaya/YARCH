// Главная вью модуля CatalogDetails

import UIKit

extension CatalogDetailsView {
    struct Appearance {
    }
}

class CatalogDetailsView: UIView {
    weak var refreshActionsDelegate: CatalogErrorViewDelegate?
    weak var delegate: CatalogDetailsViewControllerDelegate? {
        didSet {
            detailView.clickDelegate = delegate
        }
    }

    let appearance: Appearance

    let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    let detailView: CatalogDetailContentView

    lazy var emptyView = CatalogEmptyView()

    lazy var errorView: CatalogErrorView = {
        let view = CatalogErrorView()
        view.delegate = self.refreshActionsDelegate
        return view
    }()

    init(frame: CGRect = CGRect.zero,
         loadingDataSource: UITableViewDataSource,
         loadingDelegate: UITableViewDelegate,
         refreshDelegate: CatalogErrorViewDelegate,
         clickDelegate: CatalogDetailsViewControllerDelegate,
         appearance: Appearance = Appearance()) {

        detailView = CatalogDetailContentView(
            dataSource: loadingDataSource,
            delegate: loadingDelegate,
            clickDelegate: clickDelegate
        )
        self.appearance = appearance
        super.init(frame: frame)
        refreshActionsDelegate = refreshDelegate
        setup()
        addSubviews()
        makeConstraints()

        emptyView.isHidden = true
        detailView.isHidden = true
        errorView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration

    func configureHeaderView(_ viewModel: CoinSnapshotFullViewModel) {
        detailView.configureHeaderView(viewModel)
    }

    func updateTableViewData(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        showTable()
        detailView.updateTableViewData(delegate: delegate, dataSource: dataSource)
    }

    func setup() {
        self.backgroundColor = .white
    }

    func addSubviews() {
        addSubview(loadingView)
        addSubview(detailView)
        addSubview(emptyView)
        addSubview(errorView)
    }

    func showLoading() {
        show(view: loadingView)
        loadingView.startAnimating()
    }

    func showError(message: String) {
        show(view: errorView)
        errorView.title.text = message
    }

    func showTable() {
        show(view: detailView)
    }

    func show(view: UIView) {
        subviews.forEach { $0.isHidden = (view != $0) }
    }

    // MARK: Layout

    func makeConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension CatalogDetailsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
