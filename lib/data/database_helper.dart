import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:iradamobile/models/contact.dart';

import '../models/record.dart';

class DatabaseHelper {
  // static const USER_CONTACTS_TABLE_NAME = "Contacts";
  // static const CONTACT_RECORD_TABLE_NAME = "Records";
  // static const DATABASE_NAME = "irada.db";

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'irada.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE Contacts(id TEXT PRIMARY KEY, name TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE Records(id TEXT PRIMARY KEY, contactId TEXT, title TEXT, address TEXT)");

        // return db;
      },
      version: 1,
    );
  }

  Future<int> insertContact(Contact contact) async {
    int contactId = 0;
    Database _db = await database();
    await _db
        .insert('Contacts', contact.toMap(contact),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      contactId = value;
    });
    return contactId;
  }

  Future<void> updateContactName(String id, String name) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE Contacts SET name = '$name' WHERE id = '$id'");
  }

  Future<void> updateContactDescription(String id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE Contacts SET description = '$description' WHERE id = '$id'");
  }

  Future<void> insertRecord(Record record) async {
    Database _db = await database();
    await _db.insert('Records', record.toMap(record),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Contact>> getContacts() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('Contacts');
    return List.generate(taskMap.length, (index) {
      return Contact(
          id: taskMap[index]['id'].toString(),
          name: taskMap[index]['name'],
          description: taskMap[index]['description']);
    });
  }

  Future<List<Record>> getRecords(String contactId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db
        .rawQuery("SELECT * FROM Records WHERE contactId = $contactId");
    return List.generate(todoMap.length, (index) {
      return Record(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          contactId: todoMap[index]['contactId'],
          address: todoMap[index]['address']);
    });
  }

  Future<void> deleteContact(String contactId) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM Contacts WHERE id = '$contactId'");
    await _db.rawDelete("DELETE FROM Records WHERE contactId = '$contactId'");
  }

  Future<void> deleteRecord(int recordId) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM Records WHERE id = '$recordId'");
  }
}
