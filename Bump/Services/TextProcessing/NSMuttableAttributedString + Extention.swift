//
//  NSMuttableAttributedString + Extention.swift
//  Please bump
//
//  Created by Anton Cherkasov on 16.01.2023.
//

import Foundation

extension NSMutableAttributedString {

	func addAttribute(name: NSAttributedString.Key, value: Any) {
		let range = NSRange(location: 0, length: length)
		addAttribute(name, value: value, range: range)
	}

	var fullRange: NSRange {
		return NSRange(location: 0, length: length)
	}
}
