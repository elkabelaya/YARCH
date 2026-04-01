//
//  CatalogDetailsHistogramViewModel.swift
//  YARCH
//
//  Created by elka belaya  on 01.04.2026.
//  Copyright © 2026 Alfa-Bank. All rights reserved.
//

import UIKit

struct CatalogDetailsHistogramItemViewModel: Identifiable {
    let id: UniqueIdentifier
    let date: Date
    let close: Double
    let high: Double
    let low: Double
    let open: Double
}

struct CatalogDetailsHistogramViewModel {
    let title: String
    let image: UIImage?
    let data: [CatalogDetailsHistogramItemViewModel]
}
