import Foundation

class UpdateFeedManager {
	let feedUrl: URL
	var feed: Feed?
	
	init(feedUrl: URL) {
		self.feedUrl = feedUrl
	}
	
	func load() {
		let semaphore = DispatchSemaphore(value: 0)
		let task = URLSession.shared.dataTask(with: feedUrl) { data, _, error in
			guard error == nil else {
				print(error!)
				semaphore.signal()
				return
			}
			guard let data = data else {
				print("No data.")
				semaphore.signal()
				return
			}
			guard let feed = try? JSONDecoder().decode(Feed.self, from: data) else {
				print("Couldn't decode JSON.")
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
	
	func create(website: URL) {
		feed = Feed(url: website, items: [])
	}
	
	func clearItems() {
		feed?.items = []
	}
	
	func add(item: Item) {
		if feed != nil {
			feed!.items.append(item)
			sortFeed()
		} else {
			print("Feed is nil. Need to load or create feed first.")
		}
	}
	
	func sortFeed() {
		feed?.items.sort()
	}
	
	func write(to location: URL) {
		guard let feed = feed else {
			print("Feed is nil. Need to load or create feed first.")
			return
		}
		do {
			let data = try JSONEncoder().encode(feed)
			if FileManager.default.fileExists(atPath: location.relativePath) {
				try FileManager.default.removeItem(atPath: location.relativePath)
			}
			FileManager.default.createFile(atPath: location.relativePath, contents: data)
		} catch {
			print(error)
		}
	}
}
