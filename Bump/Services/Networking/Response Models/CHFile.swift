//
//  CHFile.swift
//  Bump
//
//  Created by Anton Cherkasov on 10.01.2023.
//

import Foundation

enum CHFileType: Int, Codable {

	case none = 0
	case jpg = 1
	case png = 2
	case apng = 3
	case gif = 4
	case bmp = 5
	case webm = 6
	case mp3 = 7
	case ogg = 8
	case webp = 9
	case mp4 = 10
	case sticker = 100

	var fileExtension: String {
		switch self {
			case .none:		return ""
			case .jpg:		return "jpg"
			case .png:		return "png"
			case .apng:		return "apng"
			case .gif:		return "gif"
			case .bmp:		return "bmp"
			case .webm:		return "webm"
			case .mp3:		return "mp3"
			case .ogg:		return "ogg"
			case .webp:		return "webp"
			case .mp4:		return "mp4"
			case .sticker:	return "sticker"
		}
	}
}
