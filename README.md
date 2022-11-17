<p align="center">
  <a href="https://github.com/twitter-dart/twitter-oauth2-pkce">
    <img alt="twitter_oauth2_pkce" width="500px" src="https://user-images.githubusercontent.com/13072231/202325611-78d7a154-2717-4c8b-9784-83c5a664a8e6.png">
  </a>
</p>

<p align="center">
  <b>The Optimized and Easiest Way to Integrate OAuth 2.0 PKCE with Twitter API in Flutter 🐦</b>
</p>

---

[![GitHub Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4)](https://github.com/sponsors/myConsciousness)
[![GitHub Sponsor](https://img.shields.io/static/v1?label=Maintainer&message=myConsciousness&logo=GitHub&color=00acee)](https://github.com/myConsciousness)

[![v2](https://img.shields.io/endpoint?url=https%3A%2F%2Ftwbadges.glitch.me%2Fbadges%2Fv2)](https://developer.twitter.com/en/docs/twitter-api)
[![pub package](https://img.shields.io/pub/v/twitter_oauth2_pkce.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/twitter_oauth2_pkce)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/twitter_oauth2_pkce)](https://pub.dev/packages/twitter_oauth2_pkce/)
[![Test](https://github.com/twitter-dart/twitter-oauth2-pkce/actions/workflows/test.yml/badge.svg)](https://github.com/twitter-dart/twitter-oauth2-pkce/actions/workflows/test.yml)
[![Analyzer](https://github.com/twitter-dart/twitter-oauth2-pkce/actions/workflows/analyzer.yml/badge.svg)](https://github.com/twitter-dart/twitter-oauth2-pkce/actions/workflows/analyzer.yml)
[![Issues](https://img.shields.io/github/issues/twitter-dart/twitter-oauth2-pkce?logo=github&logoColor=white)](https://github.com/twitter-dart/twitter-oauth2-pkce/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/twitter-dart/twitter-oauth2-pkce?logo=github&logoColor=white)](https://github.com/twitter-dart/twitter-oauth2-pkce/pulls)
[![Stars](https://img.shields.io/github/stars/twitter-dart/twitter-oauth2-pkce?logo=github&logoColor=white)](https://github.com/twitter-dart/twitter-oauth2-pkce)
[![Code size](https://img.shields.io/github/languages/code-size/twitter-dart/twitter-oauth2-pkce?logo=github&logoColor=white)](https://github.com/twitter-dart/twitter-oauth2-pkce)
[![Last Commits](https://img.shields.io/github/last-commit/twitter-dart/twitter-oauth2-pkce?logo=git&logoColor=white)](https://github.com/twitter-dart/twitter-oauth2-pkce/commits/main)
[![License](https://img.shields.io/github/license/twitter-dart/twitter-oauth2-pkce?logo=open-source-initiative&logoColor=green)](https://github.com/twitter-dart/twitter-oauth2-pkce/blob/main/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](https://github.com/twitter-dart/twitter-oauth2-pkce/blob/main/CODE_OF_CONDUCT.md)

---

<!-- TOC -->

- [1. Guide 🌎](#1-guide-)
  - [1.1. Getting Started ⚡](#11-getting-started-)
    - [1.1.1. Install Library](#111-install-library)
    - [1.1.2. Import](#112-import)
    - [1.1.3. Setup](#113-setup)
      - [1.1.3.1. Android](#1131-android)
      - [1.1.3.2. iOS](#1132-ios)
    - [1.1.4. Implementation](#114-implementation)
  - [1.2. Upgrading from previous versions (< 1.0.0)](#12-upgrading-from-previous-versions--100)
  - [1.3. Contribution 🏆](#13-contribution-)
  - [1.4. Support ❤️](#14-support-️)
  - [1.5. License 🔑](#15-license-)
  - [1.6. More Information 🧐](#16-more-information-)

<!-- /TOC -->

# 1. Guide 🌎

This library provides the easiest way to authenticate with [OAuth 2.0 PKCE](https://developer.twitter.com/en/docs/authentication/oauth-2-0/authorization-code) for [Twitter API](https://developer.twitter.com/en/docs/twitter-api/data-dictionary/introduction) in **Dart** and **Flutter** apps.

**Show some ❤️ and star the repo to support the project.**

We recommend using this library in combination with the **[twitter_api_v2](https://pub.dev/packages/twitter_api_v2)** which wraps the [Twitter API v2.0](https://developer.twitter.com/en/docs/twitter-api/data-dictionary/introduction)!

## 1.1. Getting Started ⚡

### 1.1.1. Install Library

**With Dart:**

```bash
 dart pub add twitter_oauth2_pkce
```

**Or With Flutter:**

```bash
 flutter pub add twitter_oauth2_pkce
```

### 1.1.2. Import

```dart
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';
```

### 1.1.3. Setup

At first to test with this library, let's set `org.example.android.oauth://callback/` as a callback URI in your [Twitter Developer](https://developer.twitter.com/en)'s portal.

![Set Callback URI](https://user-images.githubusercontent.com/13072231/173305324-14b3f7df-2606-4a5d-a348-80021a28d748.png)

#### 1.1.3.1. Android

On Android you must first set the minSdkVersion in the ***build.gradle*** file:

```gradle
defaultConfig {
   ...
   minSdkVersion 18
   ...
```

Also it's necessary to add the following definitions to `AndroidManifest.xml`.

```xml
<activity android:name="com.linusu.flutter_web_auth_2.CallbackActivity" android:exported="true">
    <intent-filter android:label="flutter_web_auth_2">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="org.example.android.oauth" android:host="callback" />
    </intent-filter>
</activity>
```

You can see details [here](https://github.com/twitter-dart/twitter-oauth2-pkce/blob/main/example/android/app/src/main/AndroidManifest.xml).

#### 1.1.3.2. iOS

On iOS you need to set the platform in the ***ios/Podfile*** file:

```profile
platform :ios, '11.0'
```

### 1.1.4. Implementation

Now all that's left is to launch the following example Flutter app and press the button to start the approval process with **OAuth 2.0 PKCE**!

After pressing the `Authorize` button, a redirect will be performed and you will see that you have obtained your bearer token and refresh token.

```dart
import 'package:flutter/material.dart';

import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';

void main() {
  runApp(const MaterialApp(home: Example()));
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String? _accessToken;
  String? _refreshToken;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Access Token: $_accessToken'),
              Text('Refresh Token: $_refreshToken'),
              ElevatedButton(
                onPressed: () async {
                  final oauth2 = TwitterOAuth2Client(
                    clientId: 'YOUR_CLIENT_ID',
                    clientSecret: 'YOUR_CLIENT_SECRET',
                    redirectUri: 'org.example.android.oauth://callback/',
                    customUriScheme: 'org.example.android.oauth',
                  );

                  final response = await oauth2.executeAuthCodeFlowWithPKCE(
                    scopes: Scope.values,
                  );

                  super.setState(() {
                    _accessToken = response.accessToken;
                    _refreshToken = response.refreshToken;
                  });
                },
                child: const Text('Push!'),
              )
            ],
          ),
        ),
      );
}
```

## 1.2. Upgrading from previous versions (< 1.0.0)

Version `1.0.0` introduced some breaking changes that need to be addressed if you are upgrading from previous versions.

Please take note of the following:

- From version 3.0.0, `flutter_web_auth` has been replaced by [`flutter_web_auth_2`](https://pub.dev/packages/flutter_web_auth_2). Please refer to the [upgrade instructions](https://pub.dev/packages/flutter_web_auth_2#upgrading-from-flutter_web_auth).
- The migration to [`flutter_web_auth_2`](https://pub.dev/packages/flutter_web_auth_2) marks the transition to `Flutter 3`. This means that you must upgrade to `Flutter 3` (a simple `flutter upgrade` should be enough).

## 1.3. Contribution 🏆

If you would like to contribute to `twitter-oauth2-pkce`, please create an [issue](https://github.com/twitter-dart/twitter-oauth2-pkce/issues) or create a Pull Request.

There are many ways to contribute to the OSS. For example, the following subjects can be considered:

- There are scopes that are not implemented.
- Documentation is outdated or incomplete.
- Have a better way or idea to achieve the functionality.
- etc...

You can see more details from resources below:

- [Contributor Covenant Code of Conduct](https://github.com/twitter-dart/twitter-oauth2-pkce/blob/main/CODE_OF_CONDUCT.md)
- [Contribution Guidelines](https://github.com/twitter-dart/twitter-oauth2-pkce/blob/main/CONTRIBUTING.md)
- [Style Guide](https://github.com/twitter-dart/twitter-oauth2-pkce/blob/main/STYLEGUIDE.md)

Or you can create a [discussion](https://github.com/twitter-dart/twitter-oauth2-pkce/discussions) if you like.

**Feel free to join this development, diverse opinions make software better!**

## 1.4. Support ❤️

The simplest way to show us your support is by **giving the project a star** at [GitHub](https://github.com/twitter-dart/twitter-oauth2-pkce) and [Pub.dev](https://pub.dev/packages/twitter_oauth2_pkce).

You can also support this project by **becoming a sponsor** on GitHub:

<div align="left">
  <p>
    <a href="https://github.com/sponsors/myconsciousness">
      <img src="https://cdn.ko-fi.com/cdn/kofi3.png?v=3" height="50" width="210" alt="myconsciousness" />
    </a>
  </p>
</div>

## 1.5. License 🔑

All resources of `twitter_oauth2_pkce` is provided under the `BSD-3` license.

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Ftwitter-dart%2Ftwitter-oauth2-pkce.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Ftwitter-dart%2Ftwitter-oauth2-pkce?ref=badge_large)

> **Note**</br>
> License notices in the source are strictly validated based on `.github/header-checker-lint.yml`. Please check [header-checker-lint.yml](https://github.com/twitter-dart/twitter-oauth2-pkce/tree/main/.github/header-checker-lint.yml) for the permitted standards.

## 1.6. More Information 🧐

`twitter_oauth2_pkce` was designed and implemented by **_Kato Shinya ([@myConsciousness](https://github.com/myConsciousness))_**.

- [Creator Profile](https://github.com/myConsciousness)
- [License](https://github.com/twitter-dart/twitter-oauth2-pkce/blob/main/LICENSE)
- [API Document](https://pub.dev/documentation/twitter_oauth2_pkce/latest/twitter_oauth2_pkce/twitter_oauth2_pkce-library.html)
- [Release Note](https://github.com/twitter-dart/twitter-oauth2-pkce/releases)
- [Bug Report](https://github.com/twitter-dart/twitter-oauth2-pkce/issues)
