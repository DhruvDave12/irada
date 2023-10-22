import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:iradamobile/providers/contacts_provider.dart';
import 'package:iradamobile/screens/contacts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  OpenAI.apiKey = dotenv.get('OPENAI_API_KEY');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DatabaseProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Irada',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                color: Colors.white,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
              ),
            )),
        home: const ContactsScreen());
  }
}
