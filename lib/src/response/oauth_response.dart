// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '../scope.dart';

class OAuthResponse {
  /// Returns the new instance of [OAuthResponse].
  OAuthResponse._({
    required this.accessToken,
    required this.refreshToken,
    required String scopes,
    required int expires,
  })  : scopes = scopes.split(' ').map((scope) => Scope.toEnum(scope)).toList(),
        expireAt = DateTime.now().add(Duration(seconds: expires));

  /// Returns the new instance of [OAuthResponse] from [json].
  factory OAuthResponse.fromJson(final Map<String, dynamic> json) =>
      OAuthResponse._(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        scopes: json['scope'],
        expires: json['expires_in'],
      );

  /// The access token.
  final String accessToken;

  /// The refresh token.
  ///
  /// Issued when `offline.access` is specified in the scope.
  final String? refreshToken;

  /// The authorized scopes.
  final List<Scope> scopes;

  /// The expiration date.
  final DateTime expireAt;

  /// Returns true if the access token is expired, otherwise false.
  bool get isExpired => DateTime.now().isAfter(expireAt);

  /// Returns true if the access token is valid, otherwise false.
  bool get isNotExpired => !isExpired;

  @override
  String toString() {
    return 'AuthResponse(accessToken: $accessToken, '
        'refreshToken: $refreshToken, scopes: $scopes, expireAt: $expireAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OAuthResponse &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        listEquals(other.scopes, scopes) &&
        other.expireAt == expireAt;
  }

  @override
  int get hashCode {
    return accessToken.hashCode ^
        refreshToken.hashCode ^
        scopes.hashCode ^
        expireAt.hashCode;
  }
}
