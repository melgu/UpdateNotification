import Foundation

/// Errors that can occur when working with an update feed.
public enum UpdateFeedError: LocalizedError {
	/// Feed is nil. Need to load or create feed first.
	case feedNotLoaded

	public var errorDescription: String? {
		switch self {
		case .feedNotLoaded:
			"Feed is nil. Need to load or create feed first."
		}
	}
}

/// The `UpdateFeedManager` class contains functions to create and edit update feeds.
public class UpdateFeedManager {
	let feedUrl: URL
	var feed: Feed?
	
	/// Initialize the UpdateFeedManager class.
	/// - Parameter feedUrl: The URL to the JSON update feed, used when loading an already existing feed.
	public init(feedUrl: URL) {
		self.feedUrl = feedUrl
	}
	
	/// Load an existing feed from the URL the class was initialized with.
	public func load() async throws {
		let request = URLRequest(url: feedUrl, cachePolicy: .reloadIgnoringCacheData)
		
		let (data, _) = try await URLSession.shared.data(for: request)
		self.feed = try JSONDecoder().decode(Feed.self, from: data)
		sortFeed()
	}
	
	/// Create a new feed
	/// - Parameter website: The main website URL
	/// - Important: The website URL is not the URL to the JSON update feed, but the website shown to the user
	public func create(website: URL) {
		feed = Feed(url: website, items: [])
	}
	
	/// Clear all itmes in the feed.
	public func clearItems() {
		feed?.items = []
	}
	
	/// Add an item to the update feed.
	/// - Parameter item: The item to be added
	public func add(item: Item) throws {
		guard feed != nil else {
			throw UpdateFeedError.feedNotLoaded
		}
		feed!.items.append(item)
		sortFeed()
	}
	
	private func sortFeed() {
		feed?.items.sort()
		feed?.items.reverse()
	}
	
	/// Write the feed to disk
	/// - Parameter location: The local URL where the feed is written to
	/// - Important: The location url needs to include the actual filename.
	public func write(to location: URL) throws {
		guard let feed = feed else {
			throw UpdateFeedError.feedNotLoaded
		}
		let data = try JSONEncoder().encode(feed)
		if FileManager.default.fileExists(atPath: location.relativePath) {
			try FileManager.default.removeItem(atPath: location.relativePath)
		}
		FileManager.default.createFile(atPath: location.relativePath, contents: data)
	}
	
	/// Log the feed and its content to the console
	public func logFeed() throws {
		guard let feed = feed else {
			throw UpdateFeedError.feedNotLoaded
		}
		
		print("--- Feed ---")
		print("Feed URL: \(feed.url)")
		print("Number of items: \(feed.items.count)")
		for item in feed.items {
			print("id: \(item.id), date: \(item.date.debugDescription), minOSVersion: \(item.minOSVersion?.string ?? "nil"), title: \(item.title.debugDescription), text: \(item.text.debugDescription)")
		}
		print("------------")
	}
}
