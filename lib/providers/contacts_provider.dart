import 'package:flutter/foundation.dart';
import 'package:iradamobile/data/database_helper.dart'; // Import your database helper
import 'package:iradamobile/models/contact.dart'; // Import your Contact model
import 'package:iradamobile/models/record.dart'; // Import your Record model

class DatabaseProvider with ChangeNotifier {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  List<Contact> contacts = [];
  List<Record> records = [];

  // Create a method to fetch data and update the state
  Future<void> fetchData() async {
    contacts = await databaseHelper.getContacts();
    // Replace with the actual contact ID
    // print(contacts);
    notifyListeners();
  }

  // Other methods to add/update/delete data

  // Example: Add a contact
  Future<void> addContact(Contact contact) async {
    await databaseHelper.insertContact(contact);
    fetchData(); // Fetch updated data
  }

  // Example: Delete a contact
  Future<void> deleteContact(Contact contact) async {
    await databaseHelper.deleteContact(contact.id);
    fetchData(); // Fetch updated data
  }
}
