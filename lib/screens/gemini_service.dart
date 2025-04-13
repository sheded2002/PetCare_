import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = "YOUR_GEMINI_API_KEY"; // ضع مفتاحك هنا
  late GenerativeModel model;

  GeminiService() {
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<String> sendMessage(String message) async {
    final response = await model.generateContent([Content.text(message)]);
    return response.text ?? "لم يتم استلام رد.";
  }
}
