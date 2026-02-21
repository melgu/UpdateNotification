# UpdateNotification

A Swift package for macOS that displays notifications about pending app updates. Once a new update is available, a prompt can appear that sends the user to the specified website to download the update. Update info is stored in a JSON feed hosted on a web server.

- **Platform:** macOS 14+
- **Swift tools version:** 6.2

## Example Integration

### Initialization

```swift
let feedUrl = URL(string: "https://website.url/app/feed.json")!
let updateNotification = UpdateNotification(feedUrl: feedUrl)
```

### Update Check

```swift
let updateAvailable = try await updateNotification.checkForUpdates()
```

To check if the latest update is newer than the currently installed app, first the version numbers are compared. If they are the same, the build numbers are compared. If both are the same (or the local installation is newer than the latest in the feed), the function returns `false`.

If the latest update specifies a minimum OS version and the current system does not meet it, the function also returns `false`.

### Show New Version View

Open a new window containing info about the latest update, if there is at least one item in the feed.

```swift
updateNotification.showNewVersionView()
```

You can also embed the view directly in your own window or layout:

```swift
let view = updateNotification.newVersionView()
```

### Show Changelog

Open a new window displaying the full changelog.

```swift
updateNotification.showChangelogWindow()
```

Or get the view to embed yourself:

```swift
let view = updateNotification.changelogView()
```

## Feed Management

```swift
let feedUrl = URL(string: "https://website.url/app/feed.json")!
let manager = UpdateFeedManager(feedUrl: feedUrl)
```

Even when creating a new feed, a feed URL is required. In that case, it doesn't need to be a working link though.

### Create

```swift
manager.create(website: URL(string: "https://website.url/app")!)
```

### Edit

```swift
try await manager.load()

let item = Item(
    version: "1.1.0",
    build: "1",
    date: Date(),
    title: "First Update",
    text: "Add customization options.",
    minOSVersion: OperatingSystemVersion(majorVersion: 10, minorVersion: 15, patchVersion: 0),
    infoUrl: URL(string: "https://website.url/app/version101")!,
    downloadUrl: URL(string: "https://website.url/app/version101/download")!
)

try manager.add(item: item)
```

All `Item` fields except `version` are optional. A minimal item can be created with just:

```swift
let item = Item(version: "1.0.0", minOSVersion: nil)
```

The Info URL should direct the user to a URL where more info about the update can be found.
The Download URL should lead to a place to download the new version or can even be a direct link to the file.

### Clear

```swift
manager.clearItems()
```

### Write / Save

This example saves the JSON file to the Downloads folder.

```swift
var path = try FileManager.default.url(
    for: .downloadsDirectory,
    in: .userDomainMask,
    appropriateFor: nil,
    create: false
)
path.appendPathComponent("feed.json")
try manager.write(to: path)
```

It is important for the path to contain the actual filename.

After writing the feed to disk, you have to upload it to your server at the path defined in your app.

## JSON Feed Format

You can also create and manage the feed manually without using the provided functions.

```json
{
    "url": "https://website.url/app",
    "items": [
        {
            "version": "1.1.0",
            "build": "2",
            "date": "",
            "title": "First Update",
            "text": "Add customization options.",
            "minOSVersion": {
                "majorVersion": 10,
                "minorVersion": 15,
                "patchVersion": 0
            },
            "infoUrl": "https://website.url/app/version101",
            "downloadUrl": "https://website.url/app/version101/download"
        },
        {
            "version": "1.0.0",
            "build": "1",
            "date": "",
            "title": "Initial Release",
            "text": "This is the first iteration.",
            "minOSVersion": {
                "majorVersion": 10,
                "minorVersion": 15,
                "patchVersion": 0
            },
            "infoUrl": "https://website.url/app/version100",
            "downloadUrl": "https://website.url/app/version100/download"
        }
    ]
}
```

Only the `version` field is required per item. All other fields (`build`, `date`, `title`, `text`, `minOSVersion`, `infoUrl`, `downloadUrl`) are optional and can be omitted from the JSON.
