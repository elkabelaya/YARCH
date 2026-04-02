//
//  CatalogDetailsHistogramItemModel.swift
//  YARCH
//
//  Created by elka belaya  on 01.04.2026.
//  Copyright © 2026 Alfa-Bank. All rights reserved.
//

import Foundation

/// Модель данных, описывающая тик
struct CatalogDetailsHistogramItemModel: Decodable {
    let time: Int
    let close: Double
    let high: Double
    let low: Double
    let open: Double
    let volumeFrom: Double
    let volumeTo: Double
    let conversionType: String
    let conversionSymbol: String

    enum CodingKeys: String, CodingKey {
        case time
        case close
        case high
        case low
        case open
        case volumeFrom   = "volumefrom"
        case volumeTo     = "volumeto"
        case conversionType
        case conversionSymbol
    }
}

extension CatalogDetailsHistogramItemModel: Equatable {
    static func == (lhs: CatalogDetailsHistogramItemModel, rhs: CatalogDetailsHistogramItemModel) -> Bool {
        return lhs.time == rhs.time
    }
}
