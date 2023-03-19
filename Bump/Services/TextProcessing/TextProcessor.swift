//
//  TextProcessor.swift
//  Please bump
//
//  Created by Anton Cherkasov on 17.01.2023.
//

import Foundation
import UIKit

struct Theme {
	var linkColor: UIColor
	var quoteColor: UIColor
}

extension Theme {

	static var post = Theme(linkColor: .orange, quoteColor: .secondaryLabel)
}

/// Interface of the text processing of the post text
protocol TextProcessorProtocol {
	func formatted(_ htmlText: String) async -> NSMutableAttributedString
}

final class TextProcessor {

	var theme: Theme = .post

	var fontSize: CGFloat = 16.0

	lazy var italicFont: UIFont = UIFont.italicSystemFont(ofSize: fontSize)

	lazy var baseFont: UIFont = UIFont.systemFont(ofSize: fontSize)


}

// MARK: - TextProcessorProtocol
extension TextProcessor: TextProcessorProtocol {

	func formatted(_ htmlText: String) async -> NSMutableAttributedString {

		guard let formatted = await convert(htmlText).mutableCopy() as? NSMutableAttributedString else {
			return .init()
		}

		formatted.beginEditing()
		processText(formatted)
		enumerateLinks(in: formatted) { range, url in
			formatted.addAttribute(.foregroundColor, value: theme.linkColor, range: range)
			formatted.addAttribute(.link, value: url, range: range)
		}
		processQuote(attributedString: formatted)
		formatted.endEditing()

		return formatted
	}
}

// MARK: - Helpers
extension TextProcessor {

	func processText(_ attributedString: NSMutableAttributedString) {
		attributedString.addAttribute(.font, value: baseFont, range: attributedString.fullRange)
		attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: attributedString.fullRange)
	}

	func enumerateLinks(in attributedString: NSMutableAttributedString, actionBlock: (NSRange, URL) -> Void) {
		let fullRange = NSRange(location: 0, length: attributedString.length)
		attributedString.enumerateAttribute(.link, in: fullRange, options: [.reverse]) { value, range, stop in
			guard let url = value as? URL else {
				return
			}
			actionBlock(range, url)
		}
	}

	func processQuote(attributedString: NSMutableAttributedString) {
		guard let regex = try? NSRegularExpression(pattern: #"^\>(?!\>).*$"#, options: [.anchorsMatchLines]) else {
			return
		}

		let fullRange = NSRange(location: 0, length: attributedString.length)

		let matches = regex.matches(in: attributedString.string, options: [], range: fullRange)
		for match in matches {
			attributedString.addAttribute(.foregroundColor, value: theme.quoteColor, range: match.range)
			attributedString.addAttribute(.font, value: italicFont, range: match.range)
		}
	}

	func convert(_ htmlText: String) async -> NSAttributedString {
		guard let data = htmlText.data(using: .utf8) else {
			return NSAttributedString()
		}

		do {
			return try NSAttributedString(data: data,
										  options: [.documentType : NSAttributedString.DocumentType.html,
													.characterEncoding: String.Encoding.utf8.rawValue],
										  documentAttributes: nil)
		} catch {
			return NSAttributedString()
		}
	}
}
