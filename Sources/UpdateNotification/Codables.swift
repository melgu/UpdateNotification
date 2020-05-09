import Foundation

struct Feed: Codable {
	var url: URL
	var items: [Item]
}

public struct Item: Codable, Identifiable, Comparable {
	public var id: String { "\(version) \(String(describing: build))" }
	var version: String
	var build: String?
	var date: Date?
	var title: String?
	var text: String?
	var infoUrl: URL?
	var downloadUrl: URL?
	
	public init(version: String, build: String? = nil, date: Date? = nil, title: String? = nil, text: String? = nil, infoUrl: URL? = nil, downloadUrl: URL? = nil) {
		self.version = version
		self.build = build
		self.date = date
		self.title = title
		self.text = text
		self.infoUrl = infoUrl
		self.downloadUrl = downloadUrl
	}
	
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
