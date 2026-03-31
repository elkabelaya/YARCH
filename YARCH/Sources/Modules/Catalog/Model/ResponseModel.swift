import Foundation

struct ResponseModel: Decodable {
    let response: String
    let message: String
    let data: [String: CatalogModel]

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message = "Message"
        case data = "Data"
    }
}
