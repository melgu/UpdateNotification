import Foundation

struct Feed: Codable {
	var url: URL
	var items: [Item]
}

struct Item: Codable, Identifiable {
	var id: String { "\(version) \(String(describing: build))" }
	var version: String
	var build: String?
	var date: Date?
	var title: String?
	var text: String?
	var infoUrl: URL?
	var downloadUrl: URL?
}
