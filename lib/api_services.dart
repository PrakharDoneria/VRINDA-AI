import 'package:dio/dio.dart';

class ApiService {
  static Future<String> sendMessage(String message) async {
    try {
      Dio dio = Dio();

      // First request to start session
      var sessionResponse = await dio.post(
        "https://vrinda.ekoahamdutivnasti.com/wp-json/mwai/v1/start_session",
      );

      String restNonce = sessionResponse.data["restNonce"];
      if (restNonce.isEmpty) {
        throw Exception("Failed to get restNonce");
      }

      // Second request using restNonce
      var chatResponse = await dio.post(
        "https://vrinda.ekoahamdutivnasti.com/wp-json/mwai-ui/v1/chats/submit",
        data: {
          "botId": "default",
          "customId": null,
          "session": "N/A",
          "chatId": "a5nsmpwl0zl",
          "contextId": 2,
          "messages": [
            {
              "id": "76s1pyvvb37",
              "role": "assistant",
              "content": "Hi! How can I help you?",
              "who": "AI: ",
              "timestamp": DateTime.now().millisecondsSinceEpoch
            }
          ],
          "newMessage": message,
          "newFileId": null,
          "stream": false
        },
        options: Options(headers: {"x-wp-nonce": restNonce}),
      );

      // Extract and return only the reply value
      return chatResponse.data["reply"] ?? "No response from AI";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
