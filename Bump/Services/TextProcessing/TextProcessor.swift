//
//  TextProcessor.swift
//  Please bump
//
//  Created by Anton Cherkasov on 17.01.2023.
//

import Foundation
import UIKit

/// Style of the text
struct TextStyle {
	var color: UIColor
	var font: UIFont
}

struct Theme {
	var defaultStyle: TextStyle = .init(color: .label, font: .systemFont(ofSize: 16.0))
	var quoteStyle: TextStyle = .init(color: .secondaryLabel, font: .italicSystemFont(ofSize: 16.0))
}

extension Theme {
	static var post = Theme()
}

/// Interface of the text processing of the post text
protocol TextProcessorProtocol {
	/// Convert HTML - text to AttributedString
	func formatted(_ htmlText: String) async -> NSMutableAttributedString
}

/// Класс обработки текста
final class TextProcessor {

	private (set) var theme = Theme()

	/// Initialization
	///
	/// - Parameters:
	///    - theme: Стиль текста
	init(theme: Theme = .post) {
		self.theme = theme
	}

}

// MARK: - TextProcessorProtocol
extension TextProcessor: TextProcessorProtocol {

	func formatted(_ htmlText: String) async -> NSMutableAttributedString {

		guard let formatted = await convert(htmlText).mutableCopy() as? NSMutableAttributedString else {
			return .init()
		}

		formatted.beginEditing()
		processText(formatted)
		processQuote(attributedString: formatted)
		formatted.endEditing()

		return formatted
	}
}

// MARK: - Helpers
extension TextProcessor {

	func processText(_ attributedString: NSMutableAttributedString) {
		let font = theme.defaultStyle.font
		let color = theme.defaultStyle.color
		attributedString.addAttribute(.font, value: font, range: attributedString.fullRange)
		attributedString.addAttribute(.foregroundColor, value: color, range: attributedString.fullRange)
	}

	func processQuote(attributedString: NSMutableAttributedString) {
		guard let regex = try? NSRegularExpression(pattern: #"^\>(?!\>).*$"#, options: [.anchorsMatchLines]) else {
			return
		}

		let fullRange = NSRange(location: 0, length: attributedString.length)

		let color = theme.quoteStyle.color
		let font = theme.quoteStyle.font

		let matches = regex.matches(in: attributedString.string, options: [], range: fullRange)
		for match in matches {
			attributedString.addAttribute(.foregroundColor, value: color, range: match.range)
			attributedString.addAttribute(.font, value: font, range: match.range)
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
