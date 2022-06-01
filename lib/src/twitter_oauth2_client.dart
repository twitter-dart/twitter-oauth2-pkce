// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:twitter_oauth2_pkce/src/scope.dart';

Future<AccessTokenResponse> getTokenWithAuthCodeFlow({
  required String clientId,
  required String clientSecret,
  required List<Scope> scopes,
  required String redirectUri,
  required String customUriScheme,
}) async =>
    await _TwitterOAuth2Client(
      redirectUri: redirectUri,
      customUriScheme: customUriScheme,
    ).getTokenWithAuthCodeFlow(
      clientId: clientId,
      clientSecret: clientSecret,
      enablePKCE: true,
      enableState: true,
      scopes: scopes.map((scope) => scope.value).toList(),
    );

class _TwitterOAuth2Client extends OAuth2Client {
  _TwitterOAuth2Client({
    required super.redirectUri,
    required super.customUriScheme,
  }) : super(
          authorizeUrl: 'https://twitter.com/i/oauth2/authorize',
          tokenUrl: 'https://api.twitter.com/2/oauth2/token',
          revokeUrl: 'https://api.twitter.com/oauth2/invalidate_token',
        );
}
