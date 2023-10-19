import 'package:flutter/material.dart';
import 'package:iradamobile/screens/AddContacts.dart';
import 'package:provider/provider.dart';

import '../data/database_helper.dart';
import '../models/contact.dart';
import '../providers/contacts_provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<void> contacts;

  @override
  void initState() {
    super.initState();
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    contacts = databaseProvider.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
        body: FutureBuilder(
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
                                style: Theme.of(context).textTheme.bodyMedium),
                            subtitle: Text(contacts[index].description!,
                                style: Theme.of(context).textTheme.bodySmall));
                      });
                }
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
            //TODO: Implement add contact
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddContacts()))
          },
        ));
  }
}
