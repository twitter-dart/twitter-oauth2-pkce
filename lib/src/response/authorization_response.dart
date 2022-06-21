// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

class AuthorizationResponse {
  /// Returns the new instance of [AuthorizationResponse].
  AuthorizationResponse({
    required this.code,
    required this.state,
  });

  /// The received code.
  final String code;

  /// The checked state.
  final String state;
}
