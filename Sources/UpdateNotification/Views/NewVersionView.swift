//
//  NewVersionView.swift
//  
//
//  Created by Melvin Gundlach on 10.08.20.
//

import SwiftUI

struct NewVersionView: View {
	let item: Item
	let currentVersion: String
	let currentBuild: String
	let url: URL
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Text("New version available")
					.font(.title)
				Text("New version: \(item.version)\(item.build != nil ? " (\(item.build!))" : ""). Current version: \(currentVersion) (\(currentBuild))")
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
						if let infoUrl = self.item.infoUrl {
							NSWorkspace.shared.open(infoUrl)
						} else {
							NSWorkspace.shared.open(self.url)
						}
					}) {
						Text("More Info")
					}
					Button(action: {
						if let downloadUrl = self.item.downloadUrl {
							NSWorkspace.shared.open(downloadUrl)
						} else {
							NSWorkspace.shared.open(self.url)
						}
					}) {
						Text("Download")
					}
				}
			}
			.padding()
		}
	}
}

struct NewVersionView_Previews: PreviewProvider {
	static let item = Item(version: "1.2.3", build: "1.2.3",
					date: Date(), title: "Demo Title",
					text: "Demo Text",
					minOSVersion: OperatingSystemVersion(majorVersion: 10, minorVersion: 15, patchVersion: 0),
					infoUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101")!,
					downloadUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101/download")!)
	
	static let feedUrl = URL(string: "http://www.melvin-gundlach.de/apps/demo/feed.json")!
	
    static var previews: some View {
		NewVersionView(item: item, currentVersion: "1.2.2", currentBuild: "1.2.2", url: feedUrl)
    }
}
