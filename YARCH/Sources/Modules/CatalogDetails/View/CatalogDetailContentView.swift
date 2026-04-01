//
//  CatalogDetailContentView.swift
//  YARCH
//
//  Created by elka belaya  on 01.04.2026.
//  Copyright © 2026 Alfa-Bank. All rights reserved.
//
import UIKit

extension CatalogDetailContentView {
    struct Appearance {
        let tableRowHeight: CGFloat = 60
        let tableHeaderViewHeight: CGFloat = 150

        let buttonText: String = "Show histogram"
        let buttonTitleColor = UIColor.darkGray
        let buttonColor = UIColor.secondarySystemBackground
        let buttonTitleHighlightedColor = UIColor.lightGray
        let buttonHeight: CGFloat = 44
        let buttonCornerRadius: CGFloat = 22
        let buttonPaddings: CGFloat = 16
    }
}

class CatalogDetailContentView: UIView {
        let appearance: Appearance
        weak var clickDelegate: CatalogDetailsViewControllerDelegate?

        private lazy var view: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()

        var tableView: UITableView

        var tableHeaderView: CatalogDetailsHeaderView? {
            return tableView.tableHeaderView as? CatalogDetailsHeaderView
        }

        lazy var histogramButton: UIButton = {
            let button = UIButton()
            button.setTitle(self.appearance.buttonText, for: .normal)
            button.setTitleColor(self.appearance.buttonTitleColor, for: .normal)
            button.setTitleColor(self.appearance.buttonTitleHighlightedColor, for: .highlighted)
            button.backgroundColor = self.appearance.buttonColor
            button.setRadius(radius: self.appearance.buttonPaddings)

            return button
        }()

        init(frame: CGRect = CGRect.zero,
             dataSource: UITableViewDataSource,
             delegate: UITableViewDelegate,
             clickDelegate: CatalogDetailsViewControllerDelegate,
             appearance: Appearance = Appearance()
        ) {
            self.appearance = appearance
            self.clickDelegate = clickDelegate
            tableView = UITableView(delegate: delegate, dataSource: dataSource)
            super.init(frame: frame)
            configureTableView()
            addSubviews()
            makeConstraints()
            histogramButton.addTarget(self, action: #selector(histogramButtonWasTapped), for: .touchUpInside)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configureHeaderView(_ viewModel: CoinSnapshotFullViewModel) {
            if let image = viewModel.image {
                tableHeaderView?.imageView.image = image
            } else {
                tableHeaderView?.imageView.showPlaceholder()
            }
        }

        func configureTableView() {
            #if !(os(tvOS))
            tableView.separatorStyle = .none
            #endif
            tableView.rowHeight = appearance.tableRowHeight
            tableView.tableHeaderView = CatalogDetailsHeaderView()
            tableView.sectionFooterHeight = UITableView.automaticDimension
            tableView.sectionHeaderHeight = UITableView.automaticDimension
        }

        func updateTableViewData(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
            tableView.tableFooterView = nil
            tableView.dataSource = dataSource
            tableView.delegate = delegate
            tableView.reloadData()

            tableView.snp.updateConstraints { make in
                make.height.equalTo(tableView.contentSize.height + appearance.tableHeaderViewHeight)
            }
        }

        func addSubviews() {
            addSubview(view)
            addSubview(tableView)
            addSubview(histogramButton)
        }

        func makeConstraints() {
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            tableView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(appearance.tableHeaderViewHeight)
            }

            tableHeaderView?.snp.makeConstraints { (make) in
                make.width.equalTo(tableView)
                make.height.equalTo(appearance.tableHeaderViewHeight)
            }
            histogramButton.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(appearance.buttonPaddings)
                make.height.equalTo(appearance.buttonHeight)
                make.top.equalTo(tableView.snp.bottom)
            }
        }

        @objc func histogramButtonWasTapped() {
            clickDelegate?.openCoinHistogram()
        }
    }
