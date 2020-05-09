import Foundation

struct Feed: Codable {
	var url: URL
	var items: [Item]
}

public struct Item: Codable, Identifiable, Comparable {
	public var id: String { "\(version) \(String(describing: build))" }
	public var version: String
	public var build: String?
	public var date: Date?
	public var title: String?
	public var text: String?
	public var infoUrl: URL?
	public var downloadUrl: URL?
	
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
