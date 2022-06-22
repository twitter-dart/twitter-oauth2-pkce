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
import 'auth/web_auth.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'auth/io_web_auth.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'auth/browser_web_auth.dart';
import 'response/authorization_response.dart';
import 'response/oauth_response.dart';
import 'scope.dart';
import 'twitter_oauth_exception.dart';

abstract class TwitterOAuth2Client {
  factory TwitterOAuth2Client({
    required String clientId,
    required String clientSecret,
    required String redirectUri,
    required String customUriScheme,
  }) =>
      _TwitterOAuth2Client(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUri: redirectUri,
        customUriScheme: customUriScheme,
      );

  Future<OAuthResponse> executeAuthCodeFlowWithPKCE({
    required List<Scope> scopes,
  });

  Future<OAuthResponse> refreshAccessToken(
    final String refreshToken,
  );
}

class _TwitterOAuth2Client implements TwitterOAuth2Client {
  _TwitterOAuth2Client({
    required String clientId,
    required String clientSecret,
    required String redirectUri,
    required String customUriScheme,
  })  : _clientId = clientId,
        _clientSecret = clientSecret,
        _redirectUri = redirectUri,
        _customUriScheme = customUriScheme;

  final String _clientId;
  final String _clientSecret;
  final String _redirectUri;
  final String _customUriScheme;

  final BaseWebAuth _webAuthClient = createWebAuth();

  @override
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

  @override
  Future<OAuthResponse> refreshAccessToken(
    final String refreshToken,
  ) async {
    final response = await http.post(
      Uri.https('api.twitter.com', '/2/oauth2/token'),
      headers: _buildAuthorizationHeader(
        clientId: _clientId,
        clientSecret: _clientSecret,
      ),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    return OAuthResponse.fromJson(jsonDecode(response.body));
  }

  Future<AuthorizationResponse> _requestAuthorization({
    required List<Scope> scopes,
    required String codeChallenge,
  }) async {
    final String state = _generateSecureAlphaNumeric(25);

    final redirectedUri = await _webAuthClient.authenticate(
      uri: Uri.https(
        'twitter.com',
        '/i/oauth2/authorize',
        {
          'response_type': 'code',
          'client_id': _clientId,
          'redirect_uri': _redirectUri,
          'scope': scopes.map((scope) => scope.value).join(' '),
          'state': state,
          'code_challenge': codeChallenge,
          'code_challenge_method': 'S256'
        },
      ),
      callbackUrlScheme: _customUriScheme,
      redirectUrl: _redirectUri,
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
        clientId: _clientId,
        clientSecret: _clientSecret,
      ),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': _redirectUri,
        'code_verifier': codeVerifier,
      },
    );

    return OAuthResponse.fromJson(jsonDecode(response.body));
  }

  Map<String, String> _buildAuthorizationHeader({
    required String clientId,
    required String clientSecret,
  }) {
    final credentials = base64.encode(utf8.encode('$clientId:$clientSecret'));

    return {'Authorization': 'Basic $credentials'};
  }

  String _generateSecureAlphaNumeric(final int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(255));

    return base64UrlEncode(values);
  }

  String _generateCodeChallenge(String codeVerifier) {
    final digest = sha256.convert(utf8.encode(codeVerifier));
    final codeChallenge = base64UrlEncode(digest.bytes);

    if (codeChallenge.endsWith('=')) {
      //! Since code challenge must contain only chars in the range
      //! ALPHA | DIGIT | "-" | "." | "_" | "~"
      //! (see https://tools.ietf.org/html/rfc7636#section-4.2)
      return codeChallenge.substring(0, codeChallenge.length - 1);
    }

    return codeChallenge;
  }
}
