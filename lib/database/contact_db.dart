import 'package:sqflite/sqflite.dart';
import 'package:flutter_app_contacts/database/database_service.dart';
import 'package:flutter_app_contacts/model/contact.dart';


class ContactDB{
  final tableName = 'contacts';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      "surname" TEXT NOT NULL,
      "phone" TEXT NOT NULL,
      PRIMARY KEY ("id" AUTOINCREMENT)
    );""");
  }

  Future<int> create ({required String name, required String surname, required String phone}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      """INSERT INTO $tableName (name, surname, phone) VALUES (?,?,?)""", 
      [name, surname, phone],
    );
  }

  Future <List<Contact>> fetchAll() async {
    final database = await DatabaseService().database;
    final contacts = await database.rawQuery(
      '''SELECT * FROM $tableName ORDER BY (id) DESC;'''
    );
    return contacts.map((contact) => Contact.fromSqfliteDatabase(contact)).toList();
  }

  Future <Contact> fetchById(int id) async {
    final database = await DatabaseService().database;
    final contact = await database.rawQuery(
      '''SELECT * from $tableName WHERE id = ?''',
      [id]
    );
    return Contact.fromSqfliteDatabase(contact.first);
  }

  Future <int> update({required int id, String? name, String? surname, String? phone}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (name != null) 'name': name,
        if (surname != null) 'surname': surname,
        if (phone != null) 'phone': phone
      },

      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future <void> delete(int id) async{
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE (id) = ?''', [id]);
  }
}