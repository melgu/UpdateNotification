import XCTest
@testable import UpdateNotification

final class UpdateNotificationTests: XCTestCase {
	func testCreate() throws {
		let manager = UpdateFeedManager(feedUrl: URL(string: "https://www.melvin-gundlach.de/apps/demo/feed.json")!)
		manager.create(website: URL(string: "https://www.melvin-gundlach.de/apps/demo")!)
		
		let item1 = Item(
			version: "1.0.0",
			minOSVersion: OperatingSystemVersion(majorVersion: 10,minorVersion: 15, patchVersion: 0)
		)
		let item2 = Item(
			version: "1.0.1",
			build: "20",
			date: Date(),
			title: "First Update",
			text: "Bugfixes",
			minOSVersion: OperatingSystemVersion(majorVersion: 10, minorVersion: 15, patchVersion: 0),
			infoUrl: URL(string: "https://www.melvin-gundlach.de/apps/demo/v101"),
			downloadUrl: URL(string: "https://www.melvin-gundlach.de/apps/demo/v101/download")
		)
		
		try manager.add(item: item1)
		try manager.add(item: item2)
		
		let data = try JSONEncoder().encode(manager.feed!)
		print(String(data: data, encoding: String.Encoding.utf8) ?? "nil")
	}
	
	func testLoad() {
		let manager = UpdateFeedManager(feedUrl: URL(string: "https://www.melvin-gundlach.de/apps/app-feeds/TidalSwift.json")!)
		let expectation = expectation(description: "Load feed")
		
		Task {
			do {
				try await manager.load()
			} catch {
				XCTFail("Failed to load feed: \(error)")
				expectation.fulfill()
				return
			}
			
			guard let feed = manager.feed else {
				XCTFail("manager.feed is nil")
				expectation.fulfill()
				return
			}
			
			guard let data = try? JSONEncoder().encode(feed) else {
				XCTFail("Can't encode feed to JSON")
				expectation.fulfill()
				return
			}
			print(String(data: data, encoding: String.Encoding.utf8) ?? "nil")
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 10)
	}
	
	func testOSVersion() {
		let os0p0p0 = OperatingSystemVersion(majorVersion: 0, minorVersion: 0, patchVersion: 0)
		let os10p0p0 = OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)
		let os11p0p0 = OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 0)
		let os11p1p0 = OperatingSystemVersion(majorVersion: 11, minorVersion: 1, patchVersion: 0)
		let os11p1p1 = OperatingSystemVersion(majorVersion: 11, minorVersion: 1, patchVersion: 1)
		let os11p0p1 = OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 1)
		
		XCTAssertEqual(os0p0p0.string, "0")
		XCTAssertEqual(os10p0p0.string, "10")
		XCTAssertEqual(os11p0p0.string, "11")
		XCTAssertEqual(os11p1p0.string, "11.1")
		XCTAssertEqual(os11p1p1.string, "11.1.1")
		XCTAssertEqual(os11p0p1.string, "11.0.1")
		
		print("System OS Version: \(ProcessInfo().operatingSystemVersion)")
		XCTAssertTrue(ProcessInfo().isOperatingSystemAtLeast(os10p0p0))
	}
	
	func testLogFeed() {
		let manager = UpdateFeedManager(feedUrl: URL(string: "https://www.melvin-gundlach.de/apps/app-feeds/Denon-Volume.json")!)
		let expectation = expectation(description: "Load and log feed")
		
		Task {
			do {
				try await manager.load()
				try manager.logFeed()
			} catch {
				XCTFail("Failed to load/log feed: \(error)")
			}
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 10)
	}
	
	static var allTests = [
		("testCreate", testCreate),
		("testLoad", testLoad),
		("testOSVersion", testOSVersion),
		("testLogFeed", testLogFeed)
	]
}
