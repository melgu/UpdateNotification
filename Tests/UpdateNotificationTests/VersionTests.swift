//
//  VersionTests.swift
//  UpdateNotification
//
//  Created by Melvin Gundlach on 22.02.26.
//

import Foundation
import Testing
@testable import UpdateNotification

@MainActor
struct VersionTests {
	@Test
	func stringLiteral() {
		let string = "1.2.3"
		let stringVersion: Version = "1.2.3"
		let version = Version(major: 1, minor: 2, patch: 3)
		
		#expect(Version(stringLiteral: string) == version)
		#expect(stringVersion == version)
	}
	
	@Test
	func invalidString() {
		let version: Version = "A.B.C"
		let expected = Version(major: 0, minor: 0, patch: 0)
		#expect(version == expected)
	}
	
	@Test
	func coding() throws {
		struct Demo: Equatable, Codable {
			let version: Version
		}
		let demo = Demo(version: Version(major: 1, minor: 2, patch: 3))
		
		let data = try JSONEncoder().encode(demo)
		let encodedString = String(data: data, encoding: .utf8)
		
		print(encodedString!)
		
		#expect(encodedString == #"{"version":"1.2.3"}"#)
		
		let decoded = try JSONDecoder().decode(Demo.self, from: data)
		
		#expect(decoded == demo)
	}
	
	@Test
	func comparison() {
		let a: Version = "10.0.0"
		let b: Version = "1.0.0"
		#expect(a > b)
	}
}
