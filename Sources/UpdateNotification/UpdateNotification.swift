import Foundation

class UpdateNotification {
	let updateFeed: UpdateFeedManager
	
	init(feedUrl: URL) {
		self.updateFeed = UpdateFeedManager(feedUrl: feedUrl)
	}
	
	func checkForUpdates(currentVersion: String, currentBuild: String) -> Bool {
		updateFeed.load()
		
		guard let feed = updateFeed.feed else {
			print("Feed unavailable.")
			return false
		}
		
		guard let lastItem = feed.items.last else {
			print("No items in feed.")
			return false
		}
		
		if lastItem.version > currentVersion {
			print("New version available.")
			return true
		}
		
		if let itemBuild = lastItem.build {
			if lastItem.version == currentVersion &&
				itemBuild > currentBuild {
				print("New version available.")
				return true
			}
		}
		
		print("No newer version available.")
		return false
	}
	
	@available(OSX 10.15, *)
	func showNewVersionView() {
		guard let lastItem = updateFeed.feed?.items.last else {
			print("Feed unavailable")
		}
		
		var currentVersion = "Unknown"
		var currentBuild = "Unknown"
		if let infoDict = Bundle.main.infoDictionary {
			currentVersion = infoDict["CFBundleShortVersionString"] as? String ?? "Unknown"
			currentBuild = infoDict["CFBundleVersion"] as? String ?? "Unknown"
		}
		
		let controller = ResizableWindowController(rootView:
			NewVersionView(item: lastItem, currentVersion: currentVersion, currentBuild: currentBuild)
		)
		controller.window?.title = "New version available"
		controller.showWindow(nil)
	}
	
	@available(OSX 10.15, *)
	func showChangelogWindow() {
		updateFeed.load()
		
		guard let items = updateFeed.feed?.items else {
			print("Feed unavailable")
			return
		}
		
		let controller = ResizableWindowController(rootView:
			FeedView(items: items)
		)
		controller.window?.title = "Changelog"
		controller.showWindow(nil)
	}
}
