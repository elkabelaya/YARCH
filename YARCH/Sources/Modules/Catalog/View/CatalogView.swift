import UIKit

class CatalogView: UIView, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    var tableView: UITableView

    lazy var emptyView = CatalogEmptyView()

    lazy var errorView: CatalogErrorView = {
        let view = CatalogErrorView()
        view.delegate = self.refreshActionsDelegate
        return view
    }()

    weak var refreshActionsDelegate: CatalogErrorViewDelegate?

    init(frame: CGRect = CGRect.zero,
         loadingDataSource: UITableViewDataSource,
         loadingDelegate: UITableViewDelegate,
         refreshDelegate: CatalogErrorViewDelegate) {
         tableView = UITableView(delegate: loadingDelegate, dataSource: loadingDataSource)
        super.init(frame: frame)
        refreshActionsDelegate = refreshDelegate
        setup()
        addSubviews()
        makeConstraints()
    }

    func setup() {
        self.backgroundColor = .white
        configureTableView()
    }

    func configureTableView() {
        #if os(iOS)
        tableView.separatorStyle = .none
        #endif
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(loadingView)
        addSubview(tableView)
        addSubview(emptyView)
        addSubview(errorView)
    }

    func makeConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.tableHeaderView?.snp.makeConstraints { (make) in
            make.width.equalTo(tableView)
            make.height.equalTo(100)
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func showEmptyView(title: String, subtitle: String) {
        show(view: emptyView)
        emptyView.title.text = title
        emptyView.subtitle.text = subtitle
    }

    func showLoading() {
        show(view: loadingView)
    }

    func showError(message: String) {
        show(view: errorView)
        errorView.title.text = message
    }

    func showTable() {
        show(view: tableView)
    }

    func show(view: UIView) {
        subviews.forEach { $0.isHidden = (view != $0) }
    }

    func show(view: UIView, view1: UIView) {
        subviews.forEach { $0.isHidden = (view != $0 && view1 != $0) }
    }

    func updateTableViewData(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        showTable()
        tableView.tableFooterView = nil
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.reloadData()
    }
}
