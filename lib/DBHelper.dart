import 'package:contactsdirectory/ContactPOJO.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  //To get Database connection
  Future<Database> getDatabase() async {
    final db = await openDatabase(
      'contacts.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'create table contactlist (id integer primary key autoincrement,name text,phone text)',
        );
      },
    );

    return db;
  }

  Future<void> addContact(ContactPOJO contactPOJO) async {
    final db = await getDatabase();
    await db.insert('contactlist', contactPOJO.toMap());
    db.close();
  }

  Future<List<ContactPOJO>> showContact() async {
    final db = await getDatabase();
    List<Map> rawQuery = await db.rawQuery('Select *from contactlist');
    List<ContactPOJO>? contactlist = rawQuery
        .map((e) => ContactPOJO.fromMap(e as Map<String, dynamic>))
        .toList();
    db.close();
    return contactlist;
  }
}
