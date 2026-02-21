import Foundation
import SwiftUI

/// The `UpdateNotification` class contains functions to check for updates and display relevant views.
public class UpdateNotification {
	/// Manages loading and exposing update feed data for this notifier.
	public let feedManager: UpdateFeedManager
	
	/// Initialize the UpdateNotification class.
	/// - Parameter feedUrl: The URL to the JSON update feed
	public init(feedUrl: URL) {
		self.feedManager = UpdateFeedManager(feedUrl: feedUrl)
	}
	
	/// Compare the latest version in the update feed to the currently installed version.
	/// - Returns: A boolean if a newer version is available
	public func checkForUpdates() async throws -> Bool {
		let infoDict = Bundle.main.infoDictionary
		let currentVersion = infoDict?["CFBundleShortVersionString"] as? String ?? "Unknown"
		let currentBuild = infoDict?["CFBundleVersion"] as? String ?? "Unknown"
		
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
	@MainActor
	public func showNewVersionView() throws {
		let controller = ResizableWindowController(rootView: newVersionView())
		controller.window?.title = "New version available"
		controller.showWindow(nil)
	}
	
	/// Build and return the `NewVersionView`.
	/// - Returns: A configured `NewVersionView`
	public func newVersionView() -> some View {
		NewVersionView(feedManager: feedManager)
	}
	
	/// Show the changelog in a new window.
	@MainActor
	public func showChangelogWindow() async throws {
		let controller = ResizableWindowController(rootView: try await changelogView())
		controller.window?.title = "Changelog"
		controller.showWindow(nil)
	}
	
	/// Build and return the changelog view.
	/// - Returns: A configured `FeedView`
	public func changelogView() async throws -> some View {
		FeedView(feedManager: feedManager)
	}
}
