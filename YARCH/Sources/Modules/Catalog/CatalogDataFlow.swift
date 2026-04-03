//  Простой модуль отображения данных в таблице.

// swiftlint:disable nesting
enum Catalog {
	// MARK: Use cases
	enum ShowItems {
		struct Request {
            var filter: String?
		}

		struct Response {
			var result: Result<[CatalogModel]>

			enum Error: Swift.Error {
				case fetchError
			}
		}

		struct ViewModel {
			var state: ViewControllerState
		}
	}

	enum ViewControllerState {
		case loading
        case filtering(String)
		case result([CatalogViewModel])
        case emptyResult(title: String, subtitle: String)
        case error(message: String)
	}
}

// swiftlint:enable nesting
