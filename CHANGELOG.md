# Release Note

## v0.2.0

- Changed the `refreshToken` field in `OAuthResponse` to **nullable**. This is because a refresh token is not issued if `offline.access` is not specified in the scope. ([#10](https://github.com/twitter-dart/twitter-oauth2-pkce/issues/10))

## v0.1.1

- Improved example.

## v0.1.0

- Processing has been optimized for Twitter.

## v0.0.1

- First Release!
