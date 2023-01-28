import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'data_model.dart';

class DB {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "AniDB.db"),
      onCreate: (database, version) async {
        await database.execute("""
        CREATE TABLE userTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname TEXT NOT NULL,
        lastname TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL
        )
        """);
      },
      version: 1,
    );
  }

  Future<bool> insertData(DataModel dataModel) async {
    final Database db = await initDB();
    db.insert("userTable", dataModel.toMap());
    return true;
  }

  Future<List<DataModel>> getData() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> data = await db.query("userTable");
    return data.map((e) => DataModel.fromMap(e)).toList();
  }

  Future<void> update(DataModel dataModel, int id) async {
    final Database db = await initDB();
    await db
        .update("userTable", dataModel.toMap(), where: "id=?", whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final Database db = await initDB();
    await db.delete("userTable", where: "id=?", whereArgs: [id]);
  }
}
