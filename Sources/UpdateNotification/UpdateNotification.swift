import Foundation


/// The `UpdateNotification` class contains functions to check for updates and display relevant views.
public class UpdateNotification {
	public let feedManager: UpdateFeedManager
	
	/// Initialize the UpdateNotification class.
	/// - Parameter feedUrl: The URL to the JSON update feed
	public init(feedUrl: URL) {
		self.feedManager = UpdateFeedManager(feedUrl: feedUrl)
	}
	
	/// Compare the latest version in the update feed to the currently installed version.
	/// - Returns: A boolean if a newer version is available
	public func checkForUpdates() async throws -> Bool {
		var currentVersion, currentBuild: String
		(currentVersion, currentBuild) = getVersionInfo()
		
		try await feedManager.load()
		
		guard let feed = feedManager.feed else {
			throw UpdateFeedError.feedNotLoaded
		}
		
		guard let firstItem = feed.items.first else {
			return false
		}
		
		if firstItem.version > currentVersion {
			print("UpdateNotification: New version available.")
			
			if let minOSVersion = firstItem.minOSVersion,
			   !ProcessInfo().isOperatingSystemAtLeast(minOSVersion) {
				print("""
					Local OS version \(ProcessInfo().operatingSystemVersion) \
					is lower than required OS version \(minOSVersion)
				""")
				return false
			}
			
			return true
		}
		
		if let itemBuild = firstItem.build {
			if firstItem.version == currentVersion &&
				itemBuild > currentBuild {
				print("UpdateNotification: New version available.")
				return true
			}
		}
		
		print("UpdateNotification: No newer version available.")
		return false
	}
	
	/// Show the `NewVersionView` in a new window.
	public func showNewVersionView() throws {
		guard let firstItem = feedManager.feed?.items.first else {
			throw UpdateFeedError.feedNotLoaded
		}
		
		var currentVersion, currentBuild: String
		(currentVersion, currentBuild) = getVersionInfo()
		
		let controller = ResizableWindowController(rootView:
			NewVersionView(item: firstItem, currentVersion: currentVersion, currentBuild: currentBuild, url: feedManager.feed!.url)
		)
		controller.window?.title = "New version available"
		controller.showWindow(nil)
	}
	
	/// Show the changelog in a new window.
	@MainActor
	public func showChangelogWindow() async throws {
		try await feedManager.load()
		
		guard let items = feedManager.feed?.items else {
			throw UpdateFeedError.feedNotLoaded
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
