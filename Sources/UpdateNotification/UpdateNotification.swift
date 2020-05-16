import Foundation


/// The `UpdateNotification` class contains functions to check for updates and display relevant views.
public class UpdateNotification {
	let updateFeed: UpdateFeedManager
	
	/// Initialize the UpdateNotification class.
	/// - Parameter feedUrl: The URL to the JSON update feed
	public init(feedUrl: URL) {
		self.updateFeed = UpdateFeedManager(feedUrl: feedUrl)
	}
	
	/// Compare the latest version in the update feed to the currently installed version.
	/// - Returns: A boolean if a newer version is available
	public func checkForUpdates() -> Bool {
		var currentVersion, currentBuild: String
		(currentVersion, currentBuild) = getVersionInfo()
		
		updateFeed.load()
		
		guard let feed = updateFeed.feed else {
			print("UpdateNotification: Feed unavailable.")
			return false
		}
		
		guard let lastItem = feed.items.last else {
			print("UpdateNotification: No items in feed.")
			return false
		}
		
		if lastItem.version > currentVersion {
			print("UpdateNotification: New version available.")
			return true
		}
		
		if let itemBuild = lastItem.build {
			if lastItem.version == currentVersion &&
				itemBuild > currentBuild {
				print("UpdateNotification: New version available.")
				return true
			}
		}
		
		print("UpdateNotification: No newer version available.")
		return false
	}
	
	/// Show the `NewVersionView` in a new window.
	public func showNewVersionView() {
		guard let lastItem = updateFeed.feed?.items.last else {
			print("UpdateNotification: Feed unavailable")
			return
		}
		
		var currentVersion, currentBuild: String
		(currentVersion, currentBuild) = getVersionInfo()
		
		let controller = ResizableWindowController(rootView:
			NewVersionView(item: lastItem, currentVersion: currentVersion, currentBuild: currentBuild, url: updateFeed.feed!.url)
		)
		controller.window?.title = "New version available"
		controller.showWindow(nil)
	}
	
	/// Show the changelog in a new window.
	public func showChangelogWindow() {
		updateFeed.load()
		
		guard let items = updateFeed.feed?.items else {
			print("UpdateNotification: Feed unavailable")
			return
		}
		
		let controller = ResizableWindowController(rootView:
			FeedView(items: items)
		)
		controller.window?.title = "Changelog"
		controller.showWindow(nil)
	}
	
	private func getVersionInfo() -> (String, String) {
		var currentVersion = "Unknown"
		var currentBuild = "Unknown"
		if let infoDict = Bundle.main.infoDictionary {
			currentVersion = infoDict["CFBundleShortVersionString"] as? String ?? "Unknown"
			currentBuild = infoDict["CFBundleVersion"] as? String ?? "Unknown"
		}
		return (currentVersion, currentBuild)
	}
}
