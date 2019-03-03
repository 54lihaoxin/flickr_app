//
//  SearchHistoryTests.swift
//  FlickrAppTests
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import XCTest
@testable import FlickrApp

final class SearchHistoryTests: XCTestCase {
    private let storageKey = "SearchHistory"
    private var existedHistory = [String]()

    override func setUp() {
        existedHistory = SearchHistory.shared.allSearchTerms
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        existedHistory.reversed().forEach {
            SearchHistory.shared.addSearchTerm(text: $0)
        }
    }

    func testAddingSearchTermsInOrder() {
        let searchHistory = SearchHistory(userDefaults: UserDefaults())
        searchHistory.addSearchTerm(text: "0")
        searchHistory.addSearchTerm(text: "1")
        searchHistory.addSearchTerm(text: "2")
        XCTAssertEqual(searchHistory.allSearchTerms, ["2", "1", "0"])
    }

    func testAddingDuplicateSearchTerm() {
        let searchHistory = SearchHistory(userDefaults: UserDefaults())
        searchHistory.addSearchTerm(text: "0")
        searchHistory.addSearchTerm(text: "1")
        searchHistory.addSearchTerm(text: "2")
        searchHistory.addSearchTerm(text: "0")
        XCTAssertEqual(searchHistory.allSearchTerms, ["0", "2", "1"])
    }
}
