import XCTest
@testable import UpdateNotification

final class UpdateNotificationTests: XCTestCase {
	func testCreate() {
		let manager = UpdateFeedManager(feedUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/feed.json")!)
		manager.create(website: URL(string: "http://www.melvin-gundlach.de/apps/demo")!)
		
		let item1 = Item(version: "1.0.0")
		let item2 = Item(version: "1.0.1",
						 build: "20",
						 date: Date(),
						 title: "First Update",
						 text: "Bugfixes",
						 infoUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101"),
						 downloadUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/v101/download"))
		
		manager.add(item: item1)
		manager.add(item: item2)
		
		let data = try? JSONEncoder().encode(manager.feed!)
		print(String(data: data!, encoding: String.Encoding.utf8) ?? "nil")
    }
	
	func testLoad() {
		let manager = UpdateFeedManager(feedUrl: URL(string: "http://www.melvin-gundlach.de/apps/demo/feed.json")!)
		manager.load()
		
		let data = try? JSONEncoder().encode(manager.feed!)
		print(String(data: data!, encoding: String.Encoding.utf8) ?? "nil")
	}

    static var allTests = [
        ("testCreate", testCreate),
		("testLoad", testLoad),
    ]
}
