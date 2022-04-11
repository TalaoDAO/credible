import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';

void main() {
  testWidgets('Get image widget with good url', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(ImageFromNetwork('success'));
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SizedBox), findsNothing);
    });
  });
  testWidgets('get SizedBox on error', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(ImageFromNetwork('https://toto.fr'));
      expect(find.byType(Image), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}

/// Based on  mocktail_image_network (https://pub.dev/packages/mocktail_image_network)

T mockNetworkImages<T>(T Function() body) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => _createHttpClient(),
  );
}

class _MockHttpClient extends Mock implements HttpClient {
  _MockHttpClient() {
    registerFallbackValue((List<int> _) {});
    registerFallbackValue(Uri());
  }

  @override
  set autoUncompress(bool _autoUncompress) {}
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

HttpClient _createHttpClient() {
  final client = _MockHttpClient();
  final request = _MockHttpClientRequest();
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();
  when(() => response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(() => response.contentLength).thenReturn(_transparentPixelPng.length);
  when(() => response.statusCode).thenReturn(HttpStatus.ok);
  when(
    () => response.listen(
      any(),
      onDone: any(named: 'onDone'),
      onError: any(named: 'onError'),
      cancelOnError: any(named: 'cancelOnError'),
    ),
  ).thenAnswer((invocation) {
    print('listen');
    final onData =
        invocation.positionalArguments[0] as void Function(List<int>);
    final onDone = invocation.namedArguments[#onDone] as void Function()?;
    return Stream<List<int>>.fromIterable(<List<int>>[_transparentPixelPng])
        .listen(onData, onDone: onDone);
  });
  when(() => request.headers).thenReturn(headers);
  when(() => client.getUrl(any())).thenAnswer((_) async {
    when(request.close).thenAnswer((_) async => response);
    return request;
  });
  when(() => client.getUrl(Uri.parse('https://toto.fr'))).thenAnswer((_) async {
    print('1');
    when(() => response.statusCode).thenReturn(HttpStatus.badGateway);
    print('2');
    when(
      () => response.listen(
        any(),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
        cancelOnError: any(named: 'cancelOnError'),
      ),
    ).thenAnswer((invocation) {
      throw Exception();
      // print('happening');
      // final onData =
      //     invocation.positionalArguments[0] as void Function(List<int>);
      // final onDone = invocation.namedArguments[#onDone] as void Function()?;
      // return Stream<List<int>>.fromIterable(<List<int>>[_transparentPixelPng])
      //     .listen(onData, onDone: onDone);
    });
    print('3');

    return request;
  });
  return client;
}

final _transparentPixelPng = base64Decode(
  '''iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==''',
);
