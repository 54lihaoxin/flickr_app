//
//  TextTableView.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import Foundation
import UIKit

protocol TextTableViewDelegate: class {
    func textTableView(_ textTableView: TextTableView, didSelectText text: String)
}

final class TextTableView: UITableView {
    private let stringArray: [String]
    private unowned let textTableViewDelegate: TextTableViewDelegate

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(stringArray: [String], unownedDelegate: TextTableViewDelegate) {
        self.stringArray = stringArray
        textTableViewDelegate = unownedDelegate
        super.init(frame: .zero, style: .plain)

        dataSource = self
        delegate = self
        registerCell(cellType: UITableViewCell.self)
    }
}

extension TextTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(cellType: UITableViewCell.self, for: indexPath)
    }
}

extension TextTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = stringArray[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textTableViewDelegate.textTableView(self, didSelectText: stringArray[indexPath.row])
    }
}
