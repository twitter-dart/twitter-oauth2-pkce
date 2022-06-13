// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:twitter_oauth2_pkce/src/scope.dart';

abstract class TwitterOAuth2 {
  factory TwitterOAuth2({
    required String clientId,
    required String clientSecret,
    required String redirectUri,
    required String customUriScheme,
  }) =>
      _TwitterOAuth2(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUri: redirectUri,
        customUriScheme: customUriScheme,
      );

  Future<AccessTokenResponse> executeAuthCodeFlowWithPKCE({
    required List<Scope> scopes,
  });

  Future<AccessTokenResponse> refreshBearerToken({
    required String bearerToken,
    required List<Scope> scopes,
  });

  Future<void> revokeBearerToken({
    required AccessTokenResponse accessTokenResponse,
  });

  Future<void> revokeRefreshToken({
    required AccessTokenResponse accessTokenResponse,
  });
}

class _TwitterOAuth2 implements TwitterOAuth2 {
  _TwitterOAuth2({
    required this.clientId,
    required this.clientSecret,
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

  /// The client ID.
  final String clientId;

  /// The client secret.
  final String clientSecret;

  @override
  Future<AccessTokenResponse> executeAuthCodeFlowWithPKCE({
    required List<Scope> scopes,
  }) async =>
      await _client.getTokenWithAuthCodeFlow(
        clientId: clientId,
        clientSecret: clientSecret,
        enablePKCE: true,
        enableState: true,
        scopes: scopes.map((scope) => scope.value).toList(),
      );

  @override
  Future<AccessTokenResponse> refreshBearerToken({
    required String bearerToken,
    required List<Scope> scopes,
  }) async =>
      await _client.refreshToken(
        bearerToken,
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: scopes.map((scope) => scope.value).toList(),
      );

  @override
  Future<void> revokeBearerToken({
    required AccessTokenResponse accessTokenResponse,
  }) async =>
      await _client.revokeAccessToken(
        accessTokenResponse,
        clientId: clientId,
        clientSecret: clientSecret,
      );

  @override
  Future<void> revokeRefreshToken({
    required AccessTokenResponse accessTokenResponse,
  }) async =>
      await _client.revokeRefreshToken(
        accessTokenResponse,
        clientId: clientId,
        clientSecret: clientSecret,
      );
}
