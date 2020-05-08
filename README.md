# UpdateNotification

Display a notification about pending app updates.
Once a new update is available, a prompt will appear that sends the user to the specified website to download the update.
Update info is stored in a JSON file on a web server that can be specified.

## Format

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
