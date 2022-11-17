# Release Note

## v1.0.0

- Just release `v1.0.0`.

## v1.0.0-preview

Version `1.0.0` introduced some breaking changes that need to be addressed if you are upgrading from previous versions.

Please take note of the following:

- From version 3.0.0, `flutter_web_auth` has been replaced by [`flutter_web_auth_2`](https://pub.dev/packages/flutter_web_auth_2). Please refer to the [upgrade instructions](https://pub.dev/packages/flutter_web_auth_2#upgrading-from-flutter_web_auth).
- The migration to [`flutter_web_auth_2`](https://pub.dev/packages/flutter_web_auth_2) marks the transition to `Flutter 3`. This means that you must upgrade to `Flutter 3` (a simple `flutter upgrade` should be enough).

## v0.5.0

- Added scopes for direct message. ([#35](https://github.com/twitter-dart/twitter-oauth2-pkce/issues/35))
  - `directMessageRead`
  - `directMessageWrite`

## v0.4.0

- Supported the process for Web Browser. ([#28](https://github.com/twitter-dart/twitter-oauth2-pkce/issues/28))

## v0.3.0

- Exposed `TwitterOAuthException` object. ([#13](https://github.com/twitter-dart/twitter-oauth2-pkce/issues/13))

## v0.2.0

- Changed the `refreshToken` field in `OAuthResponse` to **nullable**. This is because a refresh token is not issued if `offline.access` is not specified in the scope. ([#10](https://github.com/twitter-dart/twitter-oauth2-pkce/issues/10))

## v0.1.1

- Improved example.

## v0.1.0

- Processing has been optimized for Twitter.

## v0.0.1

- First Release!
