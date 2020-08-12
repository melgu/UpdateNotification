import XCTest
@testable import UpdateNotification

final class UpdateNotificationTests: XCTestCase {
	func testCreate() {
		let manager = UpdateFeedManager(feedUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/feed.json")!)
		manager.create(website: URL(string: "http://www.melvin-gundlach.de/apps/demo")!)
		
		let item1 = Item(version: "1.0.0",
						 minOSVersion: OperatingSystemVersion(majorVersion: 10,minorVersion: 15, patchVersion: 0))
		let item2 = Item(version: "1.0.1",
						 build: "20",
						 date: Date(),
						 title: "First Update",
						 text: "Bugfixes",
						 minOSVersion: OperatingSystemVersion(majorVersion: 10, minorVersion: 15, patchVersion: 0),
						 infoUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101"),
						 downloadUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101/download"))
		
		manager.add(item: item1)
		manager.add(item: item2)
		
		let data = try? JSONEncoder().encode(manager.feed!)
		print(String(data: data!, encoding: String.Encoding.utf8) ?? "nil")
    }
	
	func testLoad() {
		let manager = UpdateFeedManager(feedUrl: URL(string: "http://www.melvin-gundlach.de/apps/app-feeds/TidalSwift.json")!)
		manager.load()
		
		guard let feed = manager.feed else {
			XCTFail("manager.feed is nil")
			return
		}
		
		let data = try? JSONEncoder().encode(feed)
		print(String(data: data!, encoding: String.Encoding.utf8) ?? "nil")
	}
	
	func testOSVersion() {
		let minOSVersion = OperatingSystemVersion(majorVersion: 10,minorVersion: 15, patchVersion: 0)
		let systemOSVersion = ProcessInfo().operatingSystemVersion
		
		print("""
			minOSVersion: \(minOSVersion)
			minOSVersion: \(systemOSVersion)
			isOperatingSystemAtLeast: \(ProcessInfo().isOperatingSystemAtLeast(minOSVersion))
		""")
	}
	
	func testLogFeed() {
		let manager = UpdateFeedManager(feedUrl: URL(string: "http://www.melvin-gundlach.de/apps/app-feeds/TidalSwift.json")!)
		manager.load()
		manager.logFeed()
	}

    static var allTests = [
        ("testCreate", testCreate),
		("testLoad", testLoad),
		("testOSVersion", testOSVersion),
		("testLogFeed", testLogFeed)
    ]
}
