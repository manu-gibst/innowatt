import 'dart:io';

class AiRepository {
  const AiRepository({required HttpClient httpClient})
    : _httpClient = httpClient;

  final HttpClient _httpClient;

  Future<void> requestResponse({required String chatId}) 
}
