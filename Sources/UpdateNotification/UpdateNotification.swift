import Foundation

class UpdateNotification {
	let updateFeed: UpdateFeedManager
	
	init(feedUrl: URL) {
		self.updateFeed = UpdateFeedManager(feedUrl: feedUrl)
	}
	
	func checkForUpdates(currentVersion: String, currentBuild: String) {
		updateFeed.load()
		
		guard let feed = updateFeed.feed else {
			print("Feed unavailable.")
			return
		}
		
		guard let lastItem = feed.items.last else {
			print("No items in feed.")
			return
		}
		
		if lastItem.version > currentVersion {
			print("New version available.")
			return
		}
		
		if let itemBuild = lastItem.build {
			if lastItem.version == currentVersion &&
				itemBuild > currentBuild {
				print("New version available.")
				return
			}
		}
		
		print("No newer version available.")
	}
}
