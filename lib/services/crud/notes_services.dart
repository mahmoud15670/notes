import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class DataBaseAlradyOpenExption implements Exception {}

class DataBaseNotOpenException implements Exception {}

class UserNotFoundException implements Exception {}

class UnAbleToGetDocumentsDirectoryExption implements Exception {}

class NotesServices {
  Database? _db;
  Database _getDataBaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlradyOpenExption();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnAbleToGetDocumentsDirectoryExption();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }
  // Future<DataBaseUser> createUser({required String email}) async {
  //   final db = await _getDataBaseOrThrow();

  //   final results = db.query(userTable,limit: 1,where: 'emai = ?', whereArgs: [email]);
  //   if (results.)
  // }
  Future<void> deleteUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final user = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (user.isEmpty) {
      throw UserNotFoundException();
    } else {
      db.delete(
        userTable,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );
    }
  }
}

@immutable
class DataBaseUser {
  final int id;
  final String email;

  const DataBaseUser({
    required this.id,
    required this.email,
  });

  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'userId = $id and his email = $email';
  }

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNote {
  final int id;
  final int userId;
  final String text;

  DataBaseNote(
    this.id,
    this.userId,
    this.text,
  );

  DataBaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;
  @override
  String toString() {
    return 'note id = $id and user id = $userId';
  }

  @override
  bool operator ==(covariant DataBaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const userTable = 'user';
const noteTable = 'note';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const createUserTable = '''
CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const createNoteTable = '''
CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT ,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);
''';
