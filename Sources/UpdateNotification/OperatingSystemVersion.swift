//
//  OperatingSystemVersion.swift
//  
//
//  Created by Melvin Gundlach on 10.08.20.
//

import Foundation

extension OperatingSystemVersion: @retroactive Codable {
	public init(from decoder: Decoder) throws {
		self.init()
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.majorVersion = try values.decode(Int.self, forKey: .majorVersion)
		self.minorVersion = try values.decode(Int.self, forKey: .minorVersion)
		self.patchVersion = try values.decode(Int.self, forKey: .patchVersion)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.majorVersion, forKey: .majorVersion)
		try container.encode(self.minorVersion, forKey: .minorVersion)
		try container.encode(self.patchVersion, forKey: .patchVersion)
	}
	
	enum CodingKeys: String, CodingKey {
		case majorVersion
		case minorVersion
		case patchVersion
	}
}

extension OperatingSystemVersion: @retroactive Equatable {
	public static func == (lhs: OperatingSystemVersion, rhs: OperatingSystemVersion) -> Bool {
		return lhs.majorVersion == rhs.majorVersion
			&& lhs.minorVersion == rhs.minorVersion
			&& lhs.patchVersion == rhs.patchVersion
	}
}

extension OperatingSystemVersion {
	public var string: String {
		if self.minorVersion == 0 && self.patchVersion == 0 {
			return "\(self.majorVersion)"
		}
		if self.patchVersion == 0 {
			return "\(self.majorVersion).\(self.minorVersion)"
		}
		return "\(self.majorVersion).\(self.minorVersion).\(self.patchVersion)"
	}
}
