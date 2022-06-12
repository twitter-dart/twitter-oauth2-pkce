// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:example/scope.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';

class TwitterOAuth2 {
  TwitterOAuth2({
    required String redirectUri,
    required String customUriScheme,
  }) : _client = OAuth2Client(
          authorizeUrl: 'https://twitter.com/i/oauth2/authorize',
          tokenUrl: 'https://api.twitter.com/2/oauth2/token',
          revokeUrl: 'https://api.twitter.com/oauth2/invalidate_token',
          redirectUri: redirectUri,
          customUriScheme: customUriScheme,
        );

  /// The OAuth2 client.
  final OAuth2Client _client;

  Future<AccessTokenResponse> generateTokenWithPKCE({
    required String clientId,
    required String clientSecret,
    required List<Scope> scopes,
  }) async =>
      await _client.getTokenWithAuthCodeFlow(
        clientId: clientId,
        clientSecret: clientSecret,
        enablePKCE: true,
        enableState: true,
        scopes: scopes.map((scope) => scope.value).toList(),
      );

  Future<AccessTokenResponse> refreshBearerToken({
    required String bearerToken,
    required String clientId,
    required String clientSecret,
    required List<Scope> scopes,
  }) async =>
      await _client.refreshToken(
        bearerToken,
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: scopes.map((scope) => scope.value).toList(),
      );

  Future<void> revokeBearerToken({
    required AccessTokenResponse accessTokenResponse,
    required String clientId,
    required String clientSecret,
  }) async =>
      await _client.revokeAccessToken(
        accessTokenResponse,
        clientId: clientId,
        clientSecret: clientSecret,
      );

  Future<void> revokeRefreshToken({
    required AccessTokenResponse accessTokenResponse,
    required String clientId,
    required String clientSecret,
  }) async =>
      await _client.revokeRefreshToken(
        accessTokenResponse,
        clientId: clientId,
        clientSecret: clientSecret,
      );
}
