// Serves the UI review fixtures as a local Gitea API for simulator runs.
//
//   dart run tool/ui_review/fake_server.dart [port]
//
// Sign in with server URL http://127.0.0.1:<port> and any access token.
import 'dart:convert';
import 'dart:io';

import 'fixtures.dart';

Future<void> main(List<String> args) async {
  final port = args.isEmpty ? 8787 : int.parse(args.first);
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('Fake Gitea listening on http://127.0.0.1:$port');
  await for (final request in server) {
    final uri = request.uri;
    final result = routeFake(request.method, uri.path, uri.queryParameters);
    final response = request.response;
    if (result == null) {
      stdout.writeln('404 ${request.method} ${uri.path}');
      response.statusCode = 404;
      response.headers.contentType = ContentType.json;
      response.write('{"message":"not found"}');
    } else {
      response.headers.contentType = result is String
          ? ContentType.text
          : ContentType.json;
      response.headers.set(
        'x-total-count',
        '${result is List ? result.length : 1}',
      );
      response.add(utf8.encode(result is String ? result : jsonEncode(result)));
    }
    await response.close();
  }
}
