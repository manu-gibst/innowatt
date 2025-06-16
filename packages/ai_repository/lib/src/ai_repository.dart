import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Exception thrown when server request fails
class ServerRequestFailure implements Exception {}

// Exception thrown during authentication failure
class AuthenticationFailure implements Exception {}

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

  Future<String> generateResponse({
    required String userToken,
    required String chatId,
    required List<Map<String, dynamic>> lastMessages,
    required String summary,
  }) async {
    final body = lastMessages;
    final queryParameters = {"summary": summary};

    final request = Uri.http(
      _baseUrl,
      '/$chatId/generate-response',
      queryParameters,
    );

    print("jsonEncode(body) = ${jsonEncode(body)}");

    final response = await _httpClient.post(
      request,
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
    );

    print("${response.statusCode}: ${response.body}");

    if (response.statusCode != 200) throw ServerRequestFailure();

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (!json.containsKey('details')) throw AuthenticationFailure();

    final userId = json['details'] as String;

    return userId;
  }

  // TODO: Use this function in the BLoC and test it.
  Stream<String> getStreamResponse({
    required String userToken,
    required String chatId,
    required List<Map<String, dynamic>> lastMessages,
    required String summary,
  }) async* {
    final body = {"last_messages": lastMessages};
    final queryParameters = {"summary": summary};

    final uri = Uri.http(_baseUrl, '/$chatId/stream-response', queryParameters);

    final request =
        http.Request('POST', uri)
          ..bodyBytes = utf8.encode(jsonEncode(body))
          ..headers['Authorization'] = 'Bearer $userToken'
          ..headers['content-type'] = 'application/json';

    final response = await _httpClient.send(request);

    if (response.statusCode != 200) throw ServerRequestFailure();

    try {
      yield* response.stream.transform(utf8.decoder).transform(LineSplitter());
    } catch (e) {
      throw Exception("Error in stream: $e");
    }
  }
}
