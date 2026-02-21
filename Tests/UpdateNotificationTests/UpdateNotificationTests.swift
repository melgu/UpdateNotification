//
//  VersionTests.swift
//  UpdateNotification
//
//  Created by Melvin Gundlach on 21.02.26.
//

import Foundation
import Testing
@testable import UpdateNotification

@MainActor
struct UpdateNotificationTests {
    @Test
    func create() throws {
        let manager = UpdateFeedManager(feedUrl: URL(string: "https://www.melvin-gundlach.de/apps/demo/feed.json")!)
        manager.create(website: URL(string: "https://www.melvin-gundlach.de/apps/demo")!)

        let item1 = Item(
            version: "1.0.0",
            minOSVersion: OperatingSystemVersion(majorVersion: 10, minorVersion: 15, patchVersion: 0)
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

        let feed = try #require(manager.feed)
        let data = try JSONEncoder().encode(feed)
        print(String(data: data, encoding: .utf8) ?? "nil")
    }

    @Test
    func load() async throws {
        let manager = UpdateFeedManager(feedUrl: URL(string: "https://www.melvin-gundlach.de/apps/app-feeds/TidalSwift.json")!)

        try await manager.load()
        let feed = try #require(manager.feed)

        let data = try JSONEncoder().encode(feed)
        print(String(data: data, encoding: .utf8) ?? "nil")
    }

    @Test
    func osVersion() {
        let os0p0p0 = OperatingSystemVersion(majorVersion: 0, minorVersion: 0, patchVersion: 0)
        let os10p0p0 = OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)
        let os11p0p0 = OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 0)
        let os11p1p0 = OperatingSystemVersion(majorVersion: 11, minorVersion: 1, patchVersion: 0)
        let os11p1p1 = OperatingSystemVersion(majorVersion: 11, minorVersion: 1, patchVersion: 1)
        let os11p0p1 = OperatingSystemVersion(majorVersion: 11, minorVersion: 0, patchVersion: 1)

        #expect(os0p0p0.string == "0")
        #expect(os10p0p0.string == "10")
        #expect(os11p0p0.string == "11")
        #expect(os11p1p0.string == "11.1")
        #expect(os11p1p1.string == "11.1.1")
        #expect(os11p0p1.string == "11.0.1")

        print("System OS Version: \(ProcessInfo().operatingSystemVersion)")
        #expect(ProcessInfo().isOperatingSystemAtLeast(os10p0p0))
    }

    @Test
    func logFeed() async throws {
        let manager = UpdateFeedManager(feedUrl: URL(string: "https://www.melvin-gundlach.de/apps/app-feeds/Denon-Volume.json")!)

        try await manager.load()
        try manager.logFeed()
    }
}
