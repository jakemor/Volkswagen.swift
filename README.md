# Volkswagen.swift

CAUTION: Use this at your own risk. 

A tiny utility to cheat the App Store review process and ship any feature you want. 

## Getting Started

To use Volkswagen.swift, simply drag Volkswagen.swift into your Xcode project.

### Prerequisites

There must be a live version of your app in the App Store

### Usage

In `AppDelegate.swift`, let Volkswagen know your App's Apple ID. If your app is not yet live, skip this step.

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

  ...

  Volkswagen.shared.appId = "12341234" // From App Store Connect

}
```

Later, conditionally enable / disable features based on whether this instance of your app is under review

```
Volkswagen.shared.isAppUnderReview {
  underReview in

  if (underReview) {
    // App is Under Review
  } else {
    // App is not Under Review
  }

}
```

To force a value for `underReview` while testing:

```
Volkswagen.shared.forcedValue = false
```

## Why?

Apple tends to ban apps that compete with their own products. 

[Spotify accuses Apple of blocking app update](https://www.cultofmac.com/435952/spotify-accuses-apple-of-blocking-app-update/) (Cult of Mac)

[Apple Cracks Down on Apps That Fight iPhone Addiction](https://www.nytimes.com/2019/04/27/technology/apple-screen-time-trackers.html) (New York Times)

## How it Works

`Volkswagen.swift` hits the public iTunes API to get the latest publicly available version of your app. If the current instance of the app has a higher version than what's publicly available, Volkswagen knows the app is under review. Once your app is approved, the latest publicly available version of your app changes,  which in turn changed the way your app behaves.

## Let's Connect

Hit me up on Twitter: [@jakemor](https://twitter.com/jakemor)
