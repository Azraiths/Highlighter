//
//  HighlightableContainer.swift
//  Highlighter
//
//  Created by Ian Keen on 2017-05-16.
//  Copyright © 2017 SeungyounYi. All rights reserved.
//

import UIKit

public protocol HighlightableContainer: class {
    /// Search any child `Highlightable`s and highlight any matching text with the provided attributes
    ///
    /// - Parameters:
    ///   - text: Text to search for
    ///   - normalAttributes: Attributes to apply to non-matching text
    ///   - highlightAttributes: Attributes to apply (highlight) to matching text
    ///   - type: (optional) Only search `Highlightable`s of this type
    func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?, type: Highlightable.Type?)
    func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?, type: Highlightable.Type?, prioritizedViews: [Highlightable])
}

extension HighlightableContainer {
    public func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?, type: Highlightable.Type? = nil) {
        let mirror = Mirror(reflecting: self)
        mirror.children
            .compactMap { $0.value as? Highlightable }
            .filter { return type == nil || Swift.type(of: $0) == type }
            .forEach { $0.highlight(text: text, normal: normalAttributes, highlight: highlightAttributes)}
    }
    
    func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?, type: Highlightable.Type?, prioritizedViews: [Highlightable]) {
        let mirror = Mirror(reflecting: self)
        let priorityViewHightlighted = false
        mirror.children
            .compactMap { $0.value as? Highlightable }
            .sorted { $0.tag < $1.tag }
            .filter { return type == nil || Swift.type(of: $0) == type }
            .forEach {
                guard !priorityViewHightlighted else { return }
                $0.highlight(text: text, normal: normalAttributes, highlight: highlightAttributes)
                priorityViewHightlighted = $0.wasHightlighted && ($0.tag != 0)
            }
    }
}

extension UIView: HighlightableContainer { }
