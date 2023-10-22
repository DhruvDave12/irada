import 'dart:convert';

import 'package:iradamobile/models/constans.dart';
import 'package:dart_openai/dart_openai.dart';

class OpenAIHelper {
  Future<OpenAIResponse?> getOpenAIResponse(String userQuery) async {
    String prompt = """
    For the sentence below please give me a JSON object of the type
{
    "operation": "string",
    "name": "string",
    "chain": "string",
    "currency": "string",
    "amount": "double"
}

please pick the chain to the closest option polygon or ethereum and currency to closest option either ETH or MATIC

${userQuery}
""";
    OpenAICompletionModel completion = await OpenAI.instance.completion.create(
      model: "text-davinci-003",
      prompt: prompt,
      maxTokens: 256,
      temperature: 0.2,
      n: 1,
      // stop: ["\n"],
      echo: true,
    );

    String? generatedText = completion.choices.first.text;
    OpenAIResponse? res = getFormattedReponse(generatedText);
    return res;
  }

  OpenAIResponse? getFormattedReponse(String generatedText) {
    print("GENERATED TEXT: ${generatedText}");
    int start = generatedText.lastIndexOf('{') - 1;
    int end = generatedText.lastIndexOf('}') + 1;

    if (start == -1 || end == -1) return null;
    String trimmedString = generatedText.substring(start + 1, end);

    print("${trimmedString}");
    var jsonRes = jsonDecode(trimmedString);
    print("JSON RES: ${jsonRes}");
    OpenAIResponse response = OpenAIResponse(
        name: jsonRes["name"],
        amount: jsonRes["amount"].toDouble(),
        chain: jsonRes["chain"],
        operation: jsonRes["operation"],
        currency: jsonRes["currency"]);
    return response;
  }
}
