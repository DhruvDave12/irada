import 'package:flutter/material.dart';
import 'package:iradamobile/screens/AddContacts.dart';
import 'package:iradamobile/utils/openaiHelper.dart';
import 'package:provider/provider.dart';

import '../data/database_helper.dart';
import '../models/constans.dart';
import '../models/contact.dart';
import '../providers/contacts_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<void> contacts;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  MODAL_STATES _currentStatus = MODAL_STATES.CONFIRMATION;
  OpenAIHelper helper = OpenAIHelper();
  OpenAIResponse? response;

  @override
  void initState() {
    super.initState();
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    contacts = databaseProvider.fetchData();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      print("RESULT: ${result}");
      _lastWords = result.recognizedWords;
    });
  }

  Future<void> _processUserQuery() async {
    setState(() {
      _currentStatus = MODAL_STATES.LOADING;
    });
    OpenAIResponse? res = await helper.getOpenAIResponse(_lastWords.toString());
    setState(() {
      response = res;
      _currentStatus = MODAL_STATES.PROCESS;
    });
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    print("WORDS: ${_lastWords}");
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _speechToText.isNotListening && _lastWords != ''
              ? AlertDialog(
                  actions: [
                      _currentStatus == MODAL_STATES.CONFIRMATION
                          ? ElevatedButton(
                              onPressed: _processUserQuery,
                              child: Text('Confirm'))
                          : const SizedBox(),
                      _currentStatus == MODAL_STATES.PROCESS
                          ? ElevatedButton(
                              onPressed: () {},
                              child: Text('Create Transaction'))
                          : const SizedBox()
                    ],
                  content: Column(
                    children: [
                      _currentStatus == MODAL_STATES.CONFIRMATION
                          ? Text(_lastWords.toString(),
                              style: TextStyle(color: Colors.black))
                          : const SizedBox(),
                      _currentStatus == MODAL_STATES.LOADING
                          ? const CircularProgressIndicator()
                          : const SizedBox(),
                      _currentStatus == MODAL_STATES.PROCESS
                          ? Container(
                              child: response != null
                                  ? Text(
                                      "Do you want to proceed with ${response?.operation} ${response?.name} ${response?.amount.toString()} ${response?.currency.toString()} on ${response?.chain}",
                                      style:
                                          const TextStyle(color: Colors.black))
                                  : const Text(
                                      "Something went wrong try again!!!",
                                      style: TextStyle(color: Colors.black)),
                            )
                          : const SizedBox()
                    ],
                  ))
              : const SizedBox(),
          FutureBuilder(
              future: contacts,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                print(snapshot);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final contacts = databaseProvider.contacts;
                  print(snapshot);
                  if (contacts.isEmpty) {
                    return const Center(
                      child: Text("No contacts, time to add some"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ListTile(
                              title: Text(contacts[index].name,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              subtitle: Text(contacts[index].description!,
                                  style:
                                      Theme.of(context).textTheme.bodySmall));
                        });
                  }
                }
              }),
          Container(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(_lastWords.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 137, 196, 245),
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                        onPressed: _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                        icon: const Icon(Icons.mic)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
