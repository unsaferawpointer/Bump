//
//  HTTPMethod.swift
//  Bump
//
//  Created by Anton Cherkasov on 10.02.2023.
//

enum HTTPMethod {

	case get
	case post

	var stringValue: String {
		switch self {
			case .get:		return "GET"
			case .post:		return "POST"
		}
	}
}
