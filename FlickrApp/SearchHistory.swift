//
//  SearchHistory.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import Foundation

/**
 This is basically a first-in-first-out, no-duplicate, latest-first queue of search terms.
 */
struct SearchHistory {
    private static let maxItems = 20
    private static let storage = UserDefaults.standard
    private static let storageKey = "SearchHistory"

    static var allSearchTerms: [String] {
        return storage.stringArray(forKey: storageKey) ?? []
    }

    // O(n) time efficiency is not the best, but it's good enough for this small scale of challenge.
    static func addSearchTerm(text: String) {
        if var searchTerms = storage.stringArray(forKey: storageKey) {
            searchTerms.removeAll { $0 == text } // remove duplicate
            searchTerms.insert(text, at: 0)
            storage.setStringArrayValue(Array(searchTerms.prefix(maxItems)), forKey: storageKey)
        } else {
            storage.setStringArrayValue([text], forKey: storageKey)
        }
    }
}

private extension UserDefaults {
    // enforce type correctness
    func setStringArrayValue(_ strings: [String], forKey key: String) {
        setValue(strings, forKey: key)
    }
}
