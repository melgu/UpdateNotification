//
//  NewVersionView.swift
//  
//
//  Created by Melvin Gundlach on 10.08.20.
//

import SwiftUI

struct NewVersionView: View {
	let feedManager: UpdateFeedManager
	
	@State private var isLoading = true
	@Environment(\.openURL) private var openURL
	
	var body: some View {
		Group {
			if isLoading {
				ProgressView()
					.controlSize(.large)
					.task {
						try? await feedManager.load()
						isLoading = false
					}
			} else {
				ScrollView {
					VStack(alignment: .leading) {
						Text("New version available")
							.font(.title)
						
						if let feed = feedManager.feed, let item = feed.items.first {
							Text("New version: \(item.version.localizedStringResource)\(item.build != nil ? " (\(item.build!))" : ""). Current version: \(currentVersion) (\(currentBuild))")
							Divider()
							if let title = item.title {
								Text(title)
									.font(.headline)
							}
							if let text = item.text {
								Text(text)
							}
							if let date = item.date {
								Text("Release: \(ISO8601DateFormatter().string(from: date))")
									.foregroundColor(.gray)
							}
							if let minOSVersion = item.minOSVersion {
								Text("Minimum OS: \(minOSVersion.string)")
									.foregroundColor(.gray)
							}
							HStack {
								Spacer(minLength: 0)
								Button(action: {
									if let infoUrl = item.infoUrl {
										openURL(infoUrl)
									} else {
										openURL(feed.url)
									}
								}) {
									Text("More Info")
								}
								Button(action: {
									if let downloadUrl = item.downloadUrl {
										openURL(downloadUrl)
									} else {
										openURL(feed.url)
									}
								}) {
									Text("Download")
								}
							}
						} else {
							Text("No release information available.")
						}
					}
					.padding()
				}
			}
		}
		.frame(minWidth: 500, minHeight: 300)
	}
	
	private var currentVersion: String {
		Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
	}
	
	private var currentBuild: String {
		Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
	}
}

#Preview {
	let firstItem = Item( // Should not be visible. Just to make sure.
		version: "1.2.3",
		build: "1.2.3",
		date: Date(),
		title: "First Title",
		text: "First Text",
		minOSVersion: OperatingSystemVersion(
			majorVersion: 10,
			minorVersion: 15,
			patchVersion: 0
		),
		infoUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101")!,
		downloadUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101/download")!
	)
	let secondItem = Item(
		version: "1.2.4",
		build: "1.2.4",
		date: Date().addingTimeInterval(-86_400),
		title: "Second Title",
		text: "Second Text",
		minOSVersion: OperatingSystemVersion(
			majorVersion: 11,
			minorVersion: 0,
			patchVersion: 0
		),
		infoUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v102")!,
		downloadUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v102/download")!
	)
	let feedManager: UpdateFeedManager = {
		let manager = UpdateFeedManager(feedUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/feed.json")!)
		manager.create(website: URL(string: "http://www.melvin-gundlach.de/apps/demo")!)
		try? manager.add(item: firstItem)
		try? manager.add(item: secondItem)
		return manager
	}()
	NewVersionView(feedManager: feedManager)
}
