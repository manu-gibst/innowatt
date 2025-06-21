import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// Exception thrown when server request fails
class ServerRequestFailure implements Exception {}

// Exception thrown during authentication failure
class AuthenticationFailure implements Exception {}

// Exception thrown during response generation request
class ResponseGenerationFailure implements Exception {}

/// {@template ai_repository}
/// Repository which manages connection to backend AI. \\
/// To get an instance of [AiRepository] you have to call
/// `AiRepository.aiRepository(httpClient: http.Client())`
/// {@endtemplate}
class AiRepository {
  /// {@macro ai_repository}
  /// Private constuctor, that won't be visible to users
  /// as we have an async constructor
  AiRepository({http.Client? httpClient, required String baseUrl})
    : _httpClient = httpClient ?? http.Client(),
      _baseUrl = baseUrl;

  /// Base url for making API requests
  final String _baseUrl;

  /// HTTP Client to make API requests
  final http.Client _httpClient;

  Future<String> getUserId({required String userToken}) async {
    final request = Uri.http(_baseUrl, '/userid');

    final response = await _httpClient.get(
      request,
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode != 200) throw ServerRequestFailure();

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (!json.containsKey('id')) throw AuthenticationFailure();

    final userId = json['id'] as String;

    return userId;
  }

  Future<void> requestResponse({
    required String userToken,
    required String chatId,
    required String query,
    required List<Map<String, dynamic>> lastMessages,
  }) async {
    final queryParameters = {"query": query};
    final body = lastMessages;

    final request = Uri.http(
      _baseUrl,
      '/$chatId/get-response',
      queryParameters,
    );

    final response = await _httpClient.post(
      request,
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) throw ServerRequestFailure();

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (!json.containsKey('message')) throw ResponseGenerationFailure();

    if (json['message'] != 'success') throw ResponseGenerationFailure();
  }

  Stream<String> streamResponse({
    required String userToken,
    required String chatId,
    required String query,
    required List<Map<String, dynamic>> lastMessages,
  }) async* {
    final queryParameters = {"query": query};
    final body = lastMessages;

    final uri = Uri.http(_baseUrl, '/$chatId/stream-response', queryParameters);

    final request =
        http.Request('POST', uri)
          ..bodyBytes = utf8.encode(jsonEncode(body))
          ..headers['Authorization'] = 'Bearer $userToken'
          ..headers['Content-Type'] = 'application/json';

    final response = await _httpClient.send(request);

    if (response.statusCode != 200) throw ServerRequestFailure();

    yield* response.stream.transform(utf8.decoder).transform(LineSplitter());
  }
}
