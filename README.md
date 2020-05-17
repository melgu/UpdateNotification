# UpdateNotification

Display a notification about pending app updates.
Once a new update is available, a prompt will appear that sends the user to the specified website to download the update.
Update info is stored in a JSON file on a web server that can be specified.

Full documentation: [http://melvin-gundlach.de/Documentation/UpdateNotification/](http://melvin-gundlach.de/Documentation/UpdateNotification/)

## Example Integration

### Initialization

```swift
let feedUrl = URL(string: "http://www.melvin-gundlach.de/apps/app-feeds/Denon-Volume.json")!
let updateNotification = UpdateNotification(feedUrl: feedUrl)
```

### Update Check

```swift
let updateAvailable = updateNotification.checkForUpdates()
```

To check if the latest update is newer than the currently installed app, first the version numbers are compared. If they are the same, the build numbers are compared. If both are the same (or the local installation is newer than the latest in the feed), the function returns `false`.

### Show New Version View

Open a new window containing info about the latest update, if there is at least one item in the feed.

```
updateNotification.showNewVersionView()
```

### Show Changelog

Open a new window displaying the full changelog.

```swift
updateNotification.showChangelogWindow()
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
manager.load()

let item = Item(version: "1.1.0",
                build: "1",
                date: Date(),
                title: "First Update",
                text: "Add customization options.",
                infoUrl: URL(string: "https://website.url/app/version101")!,
                downloadUrl: URL(string: "https://website.url/app/version101/download")!)

manager.add(item: item)
```

The Info URL should direct the user to a URL were more info about the update can be found.
The Download URL should lead to a place to download the new version or can even be a direct link to the file.

### Clear

```swift
manager.clearItems()
```

### Write / Save

This example saves the JSON file to the Downloads folder.

```swift
var path = try! FileManager.default.url(for: .downloadsDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
path.appendPathComponent("feed.json")
manager.write(to: path)
```

It is important for the path to contain the actual filename.

After writing the feed to disk, you have to upload it to your server at the path defined in your app.

## JSON Feed Format

You can also just create and manage the feed without using the provided functions.

```json
{
    "url": "https://website.url/app",
    "items": [
        {
            "version": "1.1.0",
            "build": 2,
            "date": "",
            "title": "First Update",
            "text": "Add customization options.",
            "infoUrl": "https://website.url/app/version101",
            "downloadUrl": "https://website.url/app/version101/download"
        },
        {
            "version": "1.0.0",
            "build": 1,
            "date": "",
            "title": "Initial Release",
            "text": "This is the first iteration.",
            "infoUrl": "https://website.url/app/version100",
            "downloadUrl": "https://website.url/app/version100/download"
        },
    ]
}
```
