//
//  CatalogDetailsHistogramResponseModel.swift
//  YARCH
//
//  Created by elka belaya  on 01.04.2026.
//  Copyright © 2026 Alfa-Bank. All rights reserved.
//

struct CatalogDetailsHistogramResponseModel: Decodable {
    let response: String
    let message: String?
    let hasWarning: Bool
    let type: Int
    let rateLimit: RateLimit?
    let aggregated: Bool?
    let timeFrom: Double?
    let timeTo: Double?
    let data: [CatalogDetailsHistogramItemModel]?

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message   = "Message"
        case hasWarning = "HasWarning"
        case type      = "Type"
        case rateLimit = "RateLimit"
        case aggregated = "Aggregated"
        case timeFrom   = "TimeFrom"
        case timeTo     = "TimeTo"
        case data  = "Data"
    }

    struct RateLimit: Decodable {
        // Если у RateLimit будут поля
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        response   = try container.decode(String.self, forKey: .response)
        message    = try? container.decodeIfPresent(String.self, forKey: .message)
        hasWarning = try container.decode(Bool.self, forKey: .hasWarning)
        type       = try container.decode(Int.self, forKey: .type)
        rateLimit  = try? container.decodeIfPresent(RateLimit.self, forKey: .rateLimit)
        aggregated = try? container.decodeIfPresent(Bool.self, forKey: .aggregated)
        timeFrom   = try? container.decodeIfPresent(Double.self, forKey: .timeFrom)
        timeTo     = try? container.decodeIfPresent(Double.self, forKey: .timeTo)

        do {
            data = try container.decode([CatalogDetailsHistogramItemModel].self,
                                        forKey: .data)
        } catch {// если получен пустой объект вместо массива
            data = nil
        }
    }
}
