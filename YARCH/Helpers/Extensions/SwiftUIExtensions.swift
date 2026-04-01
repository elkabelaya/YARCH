//
//  SwiftUIExtensions.swift
//  YARCH
//
//  Created by elka belaya  on 01.04.2026.
//  Copyright © 2026 Alfa-Bank. All rights reserved.
//
import SwiftUI
extension View {
    func toUIViewController() -> UIViewController {
        UIHostingController(rootView: self)
    }
    
    func toUIView() -> UIView {
        self.toUIViewController().view
    }
}
