import Foundation

struct Feed: Codable {
	var url: URL
	var items: [Item]
}

/// An item describes a release in the update feed
public struct Item: Codable, Identifiable, Comparable {
	public var id: String { "\(version) \(String(describing: build))" }
	var version: String
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
	public init(version: String, build: String? = nil, date: Date? = nil, title: String? = nil, text: String? = nil, minOSVersion: OperatingSystemVersion?, infoUrl: URL? = nil, downloadUrl: URL? = nil) {
		self.version = version
		self.build = build
		self.date = date
		self.title = title
		self.text = text
		self.minOSVersion = minOSVersion
		self.infoUrl = infoUrl
		self.downloadUrl = downloadUrl
	}
	
	/// Compare two items based first on their version number and second on their build identifier
	public static func < (lhs: Item, rhs: Item) -> Bool {
		if lhs.version == rhs.version &&
			lhs.build != nil &&
			rhs.build != nil {
			return lhs.build! < rhs.build!
		} else {
			return lhs.version < rhs.version
		}
	}
}
