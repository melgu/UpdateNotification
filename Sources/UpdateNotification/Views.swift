import Foundation
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
				if item.title != nil {
					Text(item.title!)
						.font(.headline)
				}
				if item.text != nil {
					Text(item.text!)
				}
				if item.date != nil {
					Text("Release: \(ISO8601DateFormatter().string(from: item.date!))")
						.foregroundColor(.gray)
				}
				HStack {
					Spacer(minLength: 0)
					Button(action: {
						if self.item.infoUrl != nil {
							NSWorkspace.shared.open(self.item.infoUrl!)
						} else {
							NSWorkspace.shared.open(self.url)
						}
					}) {
						Text("More Info")
					}
					Button(action: {
						if self.item.downloadUrl != nil {
							NSWorkspace.shared.open(self.item.downloadUrl!)
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

class ResizableWindowController<RootView: View>: NSWindowController {
	convenience init(rootView: RootView, width: Int = 420, height: Int = 640) {
		let hostingController = NSHostingController(rootView: rootView)
		let window = NSWindow(contentViewController: hostingController)
		window.setContentSize(NSSize(width: width, height: height))
		window.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
		window.center()
		self.init(window: window)
	}
}
