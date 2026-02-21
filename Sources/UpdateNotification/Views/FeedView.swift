//
//  FeedView.swift
//  
//
//  Created by Melvin Gundlach on 10.08.20.
//

import SwiftUI

struct FeedView: View {
	let feedManager: UpdateFeedManager
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Text("Changelog")
					.font(.title)
				
				if let items = feedManager.feed?.items {
					if items.isEmpty {
						Text("No items in feed.")
					} else {
						ForEach(items) { item in
							ItemView(item: item)
							Divider()
						}
					}
				} else {
					Text("Couldn't load items.")
				}
			}
			.padding()
		}
		.task { try? await feedManager.load() }
	}
}

struct ItemView: View {
	let item: Item
	
	var body: some View {
		VStack(alignment: .leading) {
			if let title = item.title {
				Text(title)
					.font(.headline)
			}
			HStack {
				Text("Version \(item.version)\(item.build != nil ? " (\(item.build!))" : "")")
				if let date = item.date {
					Text("–")
					Text("Release:")
					Text(ISO8601DateFormatter().string(from: date))
				}
			}
			.foregroundColor(.gray)
			if let minOSVersion = item.minOSVersion {
				Text("Minimum OS: \(minOSVersion.string)")
					.foregroundColor(ProcessInfo().isOperatingSystemAtLeast(minOSVersion) ? .gray : .red)
			}
			if let text = item.text {
				Text(text)
			}
			if let infoUrl = item.infoUrl {
				HStack {
					Text("Info:")
					Text(infoUrl.absoluteString)
						.underline()
						.foregroundColor(.blue)
						.onTapGesture {
							NSWorkspace.shared.open(infoUrl)
						}
				}
			}
			if let downloadUrl = item.downloadUrl {
				HStack {
					Text("Download:")
					Text(downloadUrl.absoluteString)
						.underline()
						.foregroundColor(.blue)
						.onTapGesture {
							NSWorkspace.shared.open(downloadUrl)
						}
				}
			}
		}
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
	FeedView(feedManager: feedManager)
}


#Preview("Empty") {
	let feedManager: UpdateFeedManager = {
		let manager = UpdateFeedManager(feedUrl: URL(string: "https://example.com/feed.json")!)
		manager.create(website: URL(string: "https://example.com")!)
		return manager
	}()
	FeedView(feedManager: feedManager)
}
