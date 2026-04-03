/// Отвечает за получение данных модуля Catalog
protocol ProvidesCatalogItems {
    func getItems(filter: String?, completion: @escaping ([CatalogModel]?) -> Void)
}

struct CatalogProvider: ProvidesCatalogItems {
    let dataStore: StoresCatalogModels
    let service: FetchesCatalogItems

    init(dataStore: StoresCatalogModels = CatalogDataStore.shared, service: FetchesCatalogItems = CatalogService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func getItems(filter: String?, completion: @escaping ([CatalogModel]?) -> Void) {
        if dataStore.models?.isEmpty == false {
            return completion(self.filter(by: filter))
        }
        service.fetchItems { models in
			self.dataStore.models = models
            completion(self.filter(by: filter))
        }
    }

    private func filter(by: String?) -> [CatalogModel]? {
        if let filter = by?.lowercased(), !filter.isEmpty {
            return dataStore.models?.filter {
                $0.name.lowercased().contains(filter) ||
                $0.symbol.lowercased().contains(filter)
            }
        }
        return dataStore.models

    }
}
