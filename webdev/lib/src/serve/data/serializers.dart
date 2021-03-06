// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build_daemon/data/build_status.dart';
import 'package:built_value/serializer.dart';

import 'connect_request.dart';
import 'devtools_request.dart';

part 'serializers.g.dart';

/// Serializers for all the types used in webdev communication.
@SerializersFor([
  DevToolsRequest,
  DevToolsResponse,
  ConnectRequest,
  DefaultBuildResult,
])
final Serializers serializers = _$serializers;
