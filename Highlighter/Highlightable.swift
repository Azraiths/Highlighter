//
//  Highlightable.swift
//  Highlighter
//
//  Created by Ian Keen on 2017-05-16.
//  Copyright © 2017 SeungyounYi. All rights reserved.
//

import Foundation

public protocol Highlightable: class {
    var tag: Int { get }
    var textValue: String? { get }
    var attributedTextValue: NSAttributedString? { get set }
    func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?) -> Bool
}

extension Highlightable {
    public func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?) -> Bool {
        var wasHighlighted = false
        guard let inputText = self.textValue else { return false }

        let highlightRanges = inputText.ranges(of: text)

        guard !highlightRanges.isEmpty else {
			self.attributedTextValue = NSMutableAttributedString(string: inputText, attributes: normalAttributes)
			return false
		}
        wasHighlighted = true
        self.attributedTextValue = NSAttributedString.highlight(
            ranges: highlightRanges,
            at: text,
            in: inputText,
            normal: normalAttributes,
            highlight: highlightAttributes
        )
        return wasHighlighted
    }
}
