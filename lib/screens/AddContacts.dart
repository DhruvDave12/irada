import 'package:flutter/material.dart';
import 'package:iradamobile/models/contact.dart';
import 'package:provider/provider.dart';

import '../data/database_helper.dart';
import '../models/record.dart';
import '../providers/contacts_provider.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _walletAddressController =
      TextEditingController();

  bool isLoading = false;

  void _addContact() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    String address = _walletAddressController.text;
    Contact contact = Contact(
      id: name,
      name: name,
      description: description,
    );
    await _dbHelper.insertContact(contact);

    Record record = Record(
        id: 'default', contactId: '0', title: 'default', address: address);
    await _dbHelper.insertRecord(record);
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Contact Added Successfully'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Perform some action when the "Close" button is pressed
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: () => {Navigator.pop(context)},
          color: Colors.white,
        ),
        title: Text(
          "Add your contact",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Name',
                            hintStyle: TextStyle(
                                color: Colors.white
                                    .withOpacity(0.7)), // Hint text color
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Enter Description',
                            hintStyle: TextStyle(
                                color: Colors.white
                                    .withOpacity(0.7)), // Hint text color
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _walletAddressController,
                        decoration: InputDecoration(
                          hintText: 'Enter Address',
                          hintStyle: TextStyle(
                              color: Colors.white
                                  .withOpacity(0.7)), // Hint text color
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => {
                            setState(() => {isLoading = true}),
                            _addContact(),
                            databaseProvider.addContact(Contact(
                                id: _nameController.text,
                                name: _nameController.text,
                                description: _descriptionController.text)),
                            showSnackbar(context),
                            Navigator.pop(context)
                          },
                      child: const Text("Submit")))
            ],
          ),
        ),
      ),
    );
  }
}
