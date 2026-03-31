/// Класс для хранения данных модуля Catalog
protocol StoresCatalogModels: AnyObject {
	var models: [CatalogModel]? { get set }
}

class CatalogDataStore: StoresCatalogModels {
    static let shared = CatalogDataStore()
	var models: [CatalogModel]?
}
