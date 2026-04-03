//  Простой модуль отображения данных в таблице.

import UIKit
import Combine

protocol CatalogDisplayLogic: AnyObject {
	func displayItems(viewModel: Catalog.ShowItems.ViewModel)
}

protocol CatalogViewControllerDelegate: AnyObject {
    func openCoinDetails(_ coinId: UniqueIdentifier)
}

class CatalogViewController: UIViewController {
	let interactor: CatalogBusinessLogic
	var state: Catalog.ViewControllerState

    var loadingTableDataSource: UITableViewDataSource
    var loadingTableHandler: UITableViewDelegate

    lazy var customView = self.view as? CatalogView

    var tableDataSource: CatalogTableDataSource = CatalogTableDataSource()
    var tableHandler: CatalogTableDelegate = CatalogTableDelegate()

    let searchTextPublisher = PassthroughSubject<String, Never>()
    var cancellables = Set<AnyCancellable>()

    init(title: String,
         interactor: CatalogBusinessLogic,
         loadingDataSource: UITableViewDataSource,
         loadingTableDelegate: UITableViewDelegate,
         initialState: Catalog.ViewControllerState
    ) {
        self.interactor = interactor
        self.state = initialState
        self.loadingTableDataSource = loadingDataSource
        self.loadingTableHandler = loadingTableDelegate
        super.init(nibName: nil, bundle: nil)
        setup()
    }

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    func setup() {
        tableHandler.delegate = self
        self.title = title
        customView?.refreshActionsDelegate = self
        setupSearchDebounce()
    }

    func setupSearchDebounce() {
        searchTextPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.display(newState: .filtering(searchText))
            }
            .store(in: &cancellables)
    }

	// MARK: View lifecycle
	override func loadView() {
        let view = CatalogView(frame: UIScreen.main.bounds,
                                loadingDataSource: loadingTableDataSource,
                                loadingDelegate: loadingTableHandler,
                               refreshDelegate: self)
        self.view = view
	}

	override func viewDidLoad() {
		super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.automaticallyShowsCancelButton = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked

		display(newState: state)
	}

	// MARK: Fetching
    func fetchItems() {
        let request = Catalog.ShowItems.Request(filter: nil)
		interactor.fetchItems(request: request)
	}

    func filterItems(filter: String) {
        let request = Catalog.ShowItems.Request(filter: filter)
        interactor.fetchItems(request: request)
    }
}

extension CatalogViewController: CatalogDisplayLogic {
	func displayItems(viewModel: Catalog.ShowItems.ViewModel) {
		display(newState: viewModel.state)
    }

    func display(newState: Catalog.ViewControllerState) {
        state = newState
        switch state {
        case let .loading:
            customView?.showLoading()
            fetchItems()
        case let .filtering(filter):
            // customView?.showLoading()
            filterItems(filter: filter)
        case let .error(message):
            customView?.showError(message: message)
        case let .result(items):
            tableHandler.representableViewModels = items
            tableDataSource.representableViewModels = items
            customView?.updateTableViewData(delegate: tableHandler, dataSource: tableDataSource)
        case let .emptyResult(title, subtitle):
            customView?.showEmptyView(title: title, subtitle: subtitle)
        }
    }
}

extension CatalogViewController: CatalogViewControllerDelegate {
    func openCoinDetails(_ coinId: UniqueIdentifier) {
        let detailsController = CatalogDetailsBuilder().set(initialState: .initial(id: coinId)).build()
        navigationController?.pushViewController(detailsController, animated: true)
    }
}

extension CatalogViewController: CatalogErrorViewDelegate {
    func reloadButtonWasTapped() {
        display(newState: .loading)
    }
}

extension CatalogViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchTextPublisher.send(text)
    }
}
