//
//  TextProcessorTests.swift
//  BumpTests
//
//  Created by Anton Cherkasov on 30.03.2023.
//

import XCTest
@testable import Bump

final class TextProcessorTests: XCTestCase {

	var sut: TextProcessor!

	override func setUpWithError() throws {
		sut = TextProcessor()
	}

	override func tearDownWithError() throws {
		sut = nil
	}
}

// MARK: - TextProcessorProtocol
extension TextProcessorTests {

	func testLink() async {
		// Arrange
		let htmlText = "<a href=\"/se/res/106044.html#111615\" class=\"post-reply-link\" data-thread=\"106044\" data-num=\"111615\">>>111615</a><br>Там же есть пара college-level курсов, это оно должно быть"

		// Act
		let attributedText = await sut.formatted(htmlText)

		// Assert
		var ranges: [NSRange] = []
		attributedText.enumerateAttribute(.link, in: attributedText.fullRange) { value, range, stop in
			if let _ = value as? URL {
				ranges.append(range)
			}
		}
		XCTAssertEqual(ranges.count, 1)
		XCTAssertEqual(ranges.first, NSRange(location: 0, length: 8))
	}

	func testQuote() async {
		// Arrange
		let htmlText = ">Quote<br>Там же есть пара college-level курсов, это оно должно быть"

		// Act
		let attributedText = await sut.formatted(htmlText)

		// Assert
		var ranges: [NSRange] = []
		attributedText.enumerateAttribute(.font, in: attributedText.fullRange) { value, range, stop in
			if let _ = value as? UIFont {
				ranges.append(range)
			}
		}
		XCTAssertEqual(ranges.count, 2)
		XCTAssertEqual(ranges.first, NSRange(location: 0, length: 6))
	}
}
