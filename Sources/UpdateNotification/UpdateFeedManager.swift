import Foundation

class UpdateFeedManager {
	let feedUrl: URL
	var feed: Feed?
	
	init(feedUrl: URL) {
		self.feedUrl = feedUrl
	}
	
	func load() {
		let task = URLSession.shared.dataTask(with: feedUrl) { data, _, error in
			guard error == nil else {
				print(error!)
				return
			}
			guard let data = data else {
				print("No data.")
				return
			}
			guard let feed = try? JSONDecoder().decode(Feed.self, from: data) else {
				print("Couldn't decode JSON.")
				return
			}
			
			self.feed = feed
		}
		task.resume()
	}
	
	func create(website: URL) {
		feed = Feed(url: website, items: [])
	}
	
	func clearItems() {
		feed?.items = []
	}
	
	func add(item: Item, to url: URL) {
		if feed != nil {
			feed!.items.append(item)
		} else {
			print("Feed is nil.")
		}
	}
	
	func write(to location: URL) {
		guard let feed = feed else {
			print("Feed is nil.")
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
