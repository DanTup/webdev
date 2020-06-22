import 'dart:async';

import 'package:async/async.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shelf/shelf.dart';
import 'package:sse/server/sse_handler.dart';

abstract class SocketConnection {
  bool get isInKeepAlivePeriod;
  StreamSink<String> get sink;
  Stream<String> get stream;
  void shutdown();
}

abstract class SocketHandler<T extends SocketConnection> {
  StreamQueue<T> get connections;
  FutureOr<Response> handler(Request request);
  void shutdown();
}

class SseSocketConnection extends SocketConnection {
  final SseConnection _connection;

  SseSocketConnection(this._connection);

  @override
  bool get isInKeepAlivePeriod => _connection.isInKeepAlivePeriod;
  @override
  StreamSink<String> get sink => _connection.sink;
  @override
  Stream<String> get stream => _connection.stream;
  @override
  void shutdown() => _connection.shutdown();
}

class SseSocketHandler extends SocketHandler<SseSocketConnection> {
  final SseHandler _sseHandler;
  final StreamController<SseSocketConnection> _connectionsStream =
      StreamController<SseSocketConnection>();
  StreamQueue<SseSocketConnection> _connectionsStreamQueue;

  SseSocketHandler(this._sseHandler) {
    unawaited(() async {
      var injectedConnections = _sseHandler.connections;
      while (await injectedConnections.hasNext) {
        _connectionsStream
            .add(SseSocketConnection(await injectedConnections.next));
      }
    }());
  }

  @override
  StreamQueue<SseSocketConnection> get connections =>
      _connectionsStreamQueue ??= StreamQueue(_connectionsStream.stream);
  @override
  FutureOr<Response> handler(Request request) => _sseHandler.handler(request);
  @override
  void shutdown() => _sseHandler.shutdown();
}

class WebSocketConnection extends SocketConnection {
  WebSocketConnection();

  @override
  bool get isInKeepAlivePeriod => throw UnimplementedError();
  @override
  StreamSink<String> get sink => throw UnimplementedError();
  @override
  Stream<String> get stream => throw UnimplementedError();
  @override
  void shutdown() => throw UnimplementedError();
}

class WebSocketHandler extends SocketHandler {
  WebSocketHandler();

  @override
  StreamQueue<SocketConnection> get connections => throw UnimplementedError();
  @override
  FutureOr<Response> handler(Request request) => throw UnimplementedError();
  @override
  void shutdown() => throw UnimplementedError();
}
