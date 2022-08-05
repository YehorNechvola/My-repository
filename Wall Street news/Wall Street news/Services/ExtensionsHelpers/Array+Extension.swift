//
//  Array+Extension.swift
//  Wall Street news
//
//  Created by Егор on 04.08.2022.
//

import Foundation

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
