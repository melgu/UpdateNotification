import Foundation

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
	public func load() {
		let semaphore = DispatchSemaphore(value: 0)
		let task = URLSession.shared.dataTask(with: feedUrl) { data, _, error in
			guard error == nil else {
				print("UpdateNotification: Load: \(error!)")
				semaphore.signal()
				return
			}
			guard let data = data else {
				print("UpdateNotification: Load: No data.")
				semaphore.signal()
				return
			}
			guard let feed = try? JSONDecoder().decode(Feed.self, from: data) else {
				print("UpdateNotification: Load: Couldn't decode JSON.")
				semaphore.signal()
				return
			}
			
			self.feed = feed
			semaphore.signal()
		}
		task.resume()
		semaphore.wait()
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
	public func add(item: Item) {
		if feed != nil {
			feed!.items.append(item)
			sortFeed()
		} else {
			print("UpdateNotification: Feed is nil. Need to load or create feed first.")
		}
	}
	
	private func sortFeed() {
		feed?.items.sort()
		feed?.items.reverse()
	}
	
	/// Write the feed to disk
	/// - Parameter location: The local URL where the feed is written to
	/// - Important: The location url needs to include the actual filename.
	public func write(to location: URL) {
		guard let feed = feed else {
			print("UpdateNotification: Feed is nil. Need to load or create feed first.")
			return
		}
		do {
			let data = try JSONEncoder().encode(feed)
			if FileManager.default.fileExists(atPath: location.relativePath) {
				try FileManager.default.removeItem(atPath: location.relativePath)
			}
			FileManager.default.createFile(atPath: location.relativePath, contents: data)
		} catch {
			print("UpdateNotification: \(error)")
		}
	}
}
