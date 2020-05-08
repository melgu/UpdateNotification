import Foundation
import SwiftUI

@available(OSX 10.15, *)
struct FeedView: View {
	let items: [Item]?
	
	var body: some View {
		ScrollView {
			VStack {
				Text("Changelog")
					.font(.title)
				
				if items != nil {
					if items!.isEmpty {
						Text("No items in feed.")
					} else {
						ForEach(items!) { item in
							ItemView(item: item)
							Divider()
						}
					}
				} else {
					Text("Couldn't load items.")
				}
			}
		}
	}
}

@available(OSX 10.15, *)
struct ItemView: View {
	let item: Item
	
	var body: some View {
		VStack {
			Text("Version \(item.version)\(item.build != nil ? " (\(item.build!))" : "")")
			if item.date != nil {
				Text(ISO8601DateFormatter().string(from: item.date!))
			}
			if item.title != nil {
				Text(item.title!)
			}
			if item.text != nil {
				Text(item.text!)
			}
			if item.infoUrl != nil {
				Text(item.infoUrl!.absoluteString)
			}
			if item.downloadUrl != nil {
				Text(item.downloadUrl!.absoluteString)
			}
		}
	}
}


@available(OSX 10.15, *)
struct NewVersionView: View {
	let item: Item
	let currentVersion: String
	let currentBuild: String
	
	var body: some View {
		ScrollView {
			VStack {
				Text("New Version available: \(item.version)\(item.build != nil ? "\(item.build!)" : "")")
					.font(.title)
				Text("Current Version: \(currentVersion) (\(currentBuild)")
				Divider()
				if item.title != nil {
					Text(item.title!)
						.font(.title)
				}
				if item.text != nil {
					Text(item.text!)
				}
			}
		}
	}
}
