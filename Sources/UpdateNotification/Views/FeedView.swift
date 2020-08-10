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
			.padding()
		}
	}
}

struct ItemView: View {
	let item: Item
	
	var body: some View {
		VStack(alignment: .leading) {
			if item.title != nil {
				Text(item.title!)
					.font(.headline)
			}
			HStack {
				Text("Version \(item.version)\(item.build != nil ? " (\(item.build!))" : "")")
				if item.date != nil {
					Text("–")
					Text("Release:")
					Text(ISO8601DateFormatter().string(from: item.date!))
				}
			}
			.foregroundColor(.gray)
			if let minOSVersion = item.minOSVersion {
				Text("Minimum OS: \(minOSVersion.majorVersion).\(minOSVersion.minorVersion).\(minOSVersion.patchVersion)")
					.foregroundColor(ProcessInfo().isOperatingSystemAtLeast(minOSVersion) ? .gray : .red)
			}
			if item.text != nil {
				Text(item.text!)
			}
			if item.infoUrl != nil {
				HStack {
					Text("Info:")
					Text(item.infoUrl!.absoluteString)
						.underline()
						.foregroundColor(.blue)
						.onTapGesture {
							NSWorkspace.shared.open(self.item.infoUrl!)
					}
				}
			}
			if item.downloadUrl != nil {
				HStack {
					Text("Download:")
					Text(item.downloadUrl!.absoluteString)
						.underline()
						.foregroundColor(.blue)
						.onTapGesture {
							NSWorkspace.shared.open(self.item.downloadUrl!)
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
