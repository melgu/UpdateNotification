import Foundation

struct Feed: Codable {
	var url: URL
	var items: [Item]
}

/// An item describes a release in the update feed
public struct Item: Codable {
	var version: Version
	var build: String?
	var date: Date?
	var title: String?
	var text: String?
	var minOSVersion: OperatingSystemVersion?
	var infoUrl: URL?
	var downloadUrl: URL?
	
	/// Initialize the `Item` struct
	/// - Parameters:
	///   - version: semantic version number
	///   - build: (optional) build identifier, relevant if there are multiple releases for the same version
	///   - date: (optional) release date
	///   - title: (optional) update title
	///   - text: (optional) update text
	///   - minOSVersion: (optional) minimum reqired OS version
	///   - infoUrl: (optional) URL to the a location with more info about the update
	///   - downloadUrl: (optional) URL to the download location
	public init(
		version: String,
		build: String? = nil,
		date: Date? = nil,
		title: String? = nil,
		text: String? = nil,
		minOSVersion: OperatingSystemVersion?,
		infoUrl: URL? = nil,
		downloadUrl: URL? = nil
	) {
		self.version = Version(stringLiteral: version)
		self.build = build
		self.date = date
		self.title = title
		self.text = text
		self.minOSVersion = minOSVersion
		self.infoUrl = infoUrl
		self.downloadUrl = downloadUrl
	}
}

extension Item: Identifiable {
	public var id: String { "\(version)-\(build ?? "")" }
}

extension Item: Comparable {
	/// Compare two items based first on their version number and second on their build identifier
	public static func < (lhs: Item, rhs: Item) -> Bool {
		if lhs.version == rhs.version && lhs.build != nil && rhs.build != nil {
			lhs.build! < rhs.build!
		} else {
			lhs.version < rhs.version
		}
	}
}

public struct Version {
	let major: Int
	let minor: Int
	let patch: Int
}

extension Version: Comparable {
	public static func < (lhs: Version, rhs: Version) -> Bool {
		(lhs.major, lhs.minor, lhs.patch) < (rhs.major, rhs.minor, rhs.patch)
	}
}

extension Version: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		let components = value.split(separator: ".").compactMap { Int($0) }
		self.major = components.count > 0 ? components[0] : 0
		self.minor = components.count > 1 ? components[1] : 0
		self.patch = components.count > 2 ? components[2] : 0
	}
}

extension Version: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let string = try container.decode(String.self)
		self.init(stringLiteral: string)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode("\(major).\(minor).\(patch)")
	}
}
