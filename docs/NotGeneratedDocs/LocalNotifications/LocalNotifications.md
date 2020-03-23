##Local Notification API

This document explain API of the Local Notification

#### General Information

In order to create local notification item inside a plugin on native and react native you need:

* Add `Generic Local Notifications` plugin to your project
* In your plugin call open Api methods:
	* __Native__: Use `FacadeConnector.connector?.localNotification` this delegate object provides shared to control local notification.
	* __React Native__: Import to your code `import { localNotificationBridge } from "@applicaster/zapp-react-native-bridge/LocalNotification";` use shared API to control local notification
* To schdule local notfication with request must be passed payload dictionary, that define rules of the creation local notifications.

#### Local Notification Payload API

```JSON
 {
	identifier: String,
    title: String,
    body: String,
    unixTimestamp: Long,]
    defaultActionUrl : String,
    dismissActionUrl : String,
    actions:[
        {
            identifier: String,
            title: String,
            url: String,
            buttonType: String
        }
    ],
    attachments: [
        {
            imageUri: String
            iosOverrideImageUri: String,
            androidOverrideImageUri: String,
        }
    ]
 }
```


| Key | Type | Description | Optional
|--------|--------|--------|--------|
|identifier|String|Unique Identifier of the Local Notification Item|-|
|title|String|Title of the Item|-|
|body|String|Item's body text|YES|
|unixTimestamp|Long|Unix Timestamp date, defines when notification should fire|YES|
|defaultActionUrl|String|URL that will be called, if user tap on local notification|YES|
|dismissActionUrl|String|URL that will be called, if use erased local notification|YES|
|actions|Array|Contains Array of dictionaries that represents Action Button|YES|
|attachments|Array|Contains Array of dictionaries that represents Attachments|YES|

__Actions Data__

| Key | Type | Description | Optional
|--------|--------|--------|--------|
|identifier|String|Unique Identifier of the Action button Item|-|
|title|String|Title of the Action Item|-|
|url|String|URL that will be called, if user tap on the action button|YES|
|buttonType|String|Type of the action button|YES||-|

__Action Button Data__

| Key | Type | Description |
|--------|--------|--------|
|default|String|Default action button, in case not defined will be used as default|
|danger|String|Danger action button that defines as a red, to make some destructive calls|

__Attachments__

Maximun attachment image size can be checked [Here](https://developer.apple.com/documentation/usernotifications/unnotificationattachment)
Currently supported only 1 attachments more items will be ignored.

| Key | Type | Description | Optional
|--------|--------|--------|--------|
|imageUri|String|Item name of the local stored image, example `myImage.png`|-|
|iosOverrideImageUri|String|Has bigger priority, item name of the local stored image, example `myImage.png`|YES|
|androidOverrideImageUri|String|Android Item name of the local stored image, example `myImage.png`|YES|