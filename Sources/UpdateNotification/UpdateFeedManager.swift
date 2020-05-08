import Foundation

public class UpdateFeedManager {
	let feedUrl: URL
	var feed: Feed?
	
	public init(feedUrl: URL) {
		self.feedUrl = feedUrl
	}
	
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
	
	public func create(website: URL) {
		feed = Feed(url: website, items: [])
	}
	
	public func clearItems() {
		feed?.items = []
	}
	
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
	}
	
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
