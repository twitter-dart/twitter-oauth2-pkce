// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_oauth2_pkce/src/scope.dart';

void main() {
  test('.value', () {
    expect(Scope.tweetRead.value, 'tweet.read');
    expect(Scope.tweetWrite.value, 'tweet.write');
    expect(Scope.tweetModerateWrite.value, 'tweet.moderate.write');
    expect(Scope.usersRead.value, 'users.read');
    expect(Scope.followsRead.value, 'follows.read');
    expect(Scope.followsWrite.value, 'follows.write');
    expect(Scope.offlineAccess.value, 'offline.access');
    expect(Scope.spaceRead.value, 'space.read');
    expect(Scope.muteRead.value, 'mute.read');
    expect(Scope.muteWrite.value, 'mute.write');
    expect(Scope.likeRead.value, 'like.read');
    expect(Scope.likeWrite.value, 'like.write');
    expect(Scope.listRead.value, 'list.read');
    expect(Scope.listWrite.value, 'list.write');
    expect(Scope.blockRead.value, 'block.read');
    expect(Scope.blockWrite.value, 'block.write');
    expect(Scope.bookmarkRead.value, 'bookmark.read');
    expect(Scope.bookmarkWrite.value, 'bookmark.write');
  });
}
