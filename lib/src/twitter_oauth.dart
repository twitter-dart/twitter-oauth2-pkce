// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// Dart imports:
import 'dart:convert';
import 'dart:math';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'auth/base_web_auth.dart';
import 'response/authorization_response.dart';
import 'response/oauth_response.dart';
import 'scope.dart';
import 'twitter_oauth_exception.dart';

import 'auth/web_auth.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'auth/io_web_auth.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'auth/browser_web_auth.dart';


class TwitterOAuth {
  TwitterOAuth({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    required this.customUriScheme,
  });

  /// The client ID of application.
  final String clientId;

  /// The client secret of application.
  final String clientSecret;

  /// The redirect uri.
  final String redirectUri;

  /// The custom uri scheme.
  final String customUriScheme;

  final BaseWebAuth webAuthClient = createWebAuth();

  Future<OAuthResponse> executeAuthCodeFlowWithPKCE({
    required List<Scope> scopes,
  }) async {
    final String codeVerifier = _generateSecureAlphaNumeric(80);
    final String codeChallenge = _generateCodeChallenge(codeVerifier);

    final response = await _requestAuthorization(
      scopes: scopes,
      codeChallenge: codeChallenge,
    );

    return await _requestAccessToken(
      code: response.code,
      scopes: scopes,
      codeVerifier: codeVerifier,
    );
  }

  Future<OAuthResponse> refreshToken(
    String refreshToken, {
    required List<Scope> scopes,
  }) async {
    final response = await http.post(
      Uri.https('api.twitter.com', '/2/oauth2/token'),
      headers: _buildAuthorizationHeader(
        clientId: clientId,
        clientSecret: clientSecret,
      ),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    return OAuthResponse.fromJson(jsonDecode(response.body));
  }

  Future<OAuthResponse> revokeToken(OAuthResponse oauthResponse) async {
    await revokeAccessToken(oauthResponse);

    return await revokeRefreshToken(oauthResponse);
  }

  Future<AuthorizationResponse> _requestAuthorization({
    required List<Scope> scopes,
    required String codeChallenge,
  }) async {
    final String state = _generateSecureAlphaNumeric(25);

    final redirectedUri = await webAuthClient.authenticate(
      uri: Uri.https(
        'twitter.com',
        '/i/oauth2/authorize',
        {
          'response_type': 'code',
          'client_id': clientId,
          'redirect_uri': redirectUri,
          'scope': scopes.map((scope) => scope.value).join(' '),
          'state': state,
          'code_challenge': codeChallenge,
          'code_challenge_method': 'S256'
        },
      ),
      callbackUrlScheme: customUriScheme,
      redirectUrl: redirectUri,
    );

    final queryParameters = Uri.parse(redirectedUri).queryParameters;

    if (queryParameters.containsKey('error')) {
      throw TwitterOAuthException(queryParameters['error_description'] ?? '');
    }

    if (queryParameters['state'] != state) {
      throw TwitterOAuthException('Did not match the expected state value.');
    }

    return AuthorizationResponse(
      code: queryParameters['code']!,
      state: queryParameters['state']!,
    );
  }

  Future<OAuthResponse> _requestAccessToken({
    required List<Scope> scopes,
    required String code,
    required String codeVerifier,
  }) async {
    final response = await http.post(
      Uri.https('api.twitter.com', '/2/oauth2/token'),
      headers: _buildAuthorizationHeader(
        clientId: clientId,
        clientSecret: clientSecret,
      ),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'code_verifier': codeVerifier,
      },
    );

    return OAuthResponse.fromJson(jsonDecode(response.body));
  }

  Future<OAuthResponse> revokeAccessToken(OAuthResponse oauthResponse) async =>
      await _revokeTokenByType(
        oauthResponse,
        'access_token',
      );

  Future<OAuthResponse> revokeRefreshToken(
    OAuthResponse oauthResponse,
  ) async =>
      await _revokeTokenByType(
        oauthResponse,
        'refresh_token',
      );

  Map<String, String> _buildAuthorizationHeader({
    required String clientId,
    required String clientSecret,
  }) {
    final credentials = base64.encode(utf8.encode('$clientId:$clientSecret'));

    return {'Authorization': 'Basic $credentials'};
  }

  Future<OAuthResponse> _revokeTokenByType(
    OAuthResponse oauthResponse,
    String tokenType,
  ) async {
    final token = tokenType == 'access_token'
        ? oauthResponse.accessToken
        : oauthResponse.refreshToken;

    final response = await http.post(
      Uri.https('api.twitter.com', '/oauth2/invalidate_token'),
      body: {
        'token': token,
        'token_type_hint': tokenType,
        'client_id': clientId,
        'client_secret': clientSecret
      },
    );

    return OAuthResponse.fromJson(jsonDecode(response.body));
  }

  String _generateSecureAlphaNumeric(final int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(255));

    return base64UrlEncode(values);
  }

  String _generateCodeChallenge(String codeVerifier) {
    final digest = sha256.convert(utf8.encode(codeVerifier));
    var codeChallenge = base64UrlEncode(digest.bytes);

    if (codeChallenge.endsWith('=')) {
      //! Since code challenge must contain only chars in the range
      //! ALPHA | DIGIT | "-" | "." | "_" | "~"
      //! (see https://tools.ietf.org/html/rfc7636#section-4.2)
      //!
      //! many OAuth2 servers (read "Google") don't accept the "=" at the end of
      //! the base64 encoded string
      codeChallenge = codeChallenge.substring(0, codeChallenge.length - 1);
    }

    return codeChallenge;
  }
}
