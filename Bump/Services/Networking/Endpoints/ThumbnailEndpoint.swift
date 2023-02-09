//
//  ThumbnailEndpoint.swift
//  Bump
//
//  Created by Anton Cherkasov on 11.02.2023.
//

import Foundation

/// Endpoint for thumbnail of the media file
struct ThumbnailEndpoint: Request {

	typealias Response = Data

	var httpMethod: String {
		return HTTPMethod.get.stringValue
	}

	/// Path of the media resource
	var path: String

	/// Initialization
	///
	/// - Parameters:
	///    - path: Path of the resource
	init(path: String) {
		self.path = path
	}

}
