//
//  FeedView.swift
//  
//
//  Created by Melvin Gundlach on 10.08.20.
//

import SwiftUI

struct FeedView: View {
	let items: [Item]?
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Text("Changelog")
					.font(.title)
				
				if let items = items {
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


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			FeedView(items: [])
		}
    }
}
