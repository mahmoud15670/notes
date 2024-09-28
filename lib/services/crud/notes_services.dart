import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;


class NotesServices {
  Database? _db;
  List<DataBaseNote> _notes = [];

  final _noteStremcontrollar = StreamController.broadcast();

  Future<void>_cacheNotes() async {
    final allNotes = await getAlllNotes();
    _notes = allNotes.toList();
    _noteStremcontrollar.add(_notes);
  }

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
      await _cacheNotes();
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

  Future<DataBaseUser> createUser({required String email}) async {
    final db = _getDataBaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'emai = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) throw UserAlradyExsitsException();
    final userId = await db.insert(
      userTable,
      {emailColumn: email.toLowerCase()},
    );
    return DataBaseUser(
      id: userId,
      email: email,
    );
  }

  Future<DataBaseUser> getUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final users = await db.query(
      userTable,
      limit: 1,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if (users.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DataBaseUser.fromRow(users.first);
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDataBaseOrThrow();

    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) throw CouldNotDeleteUserException();
  }

  Future<DataBaseNote> createNote({required DataBaseUser owner}) async {
    final db = _getDataBaseOrThrow();
    final user = await getUser(email: owner.email);
    if (user != owner) throw CouldNotFindUserException();
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: '',
    });
    final note = DataBaseNote(noteId, owner.id, '');
    _notes.add(note);
    _noteStremcontrollar.add(_notes);
    return note;
  }

  Future<DataBaseNote> getNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) throw CouldNotFindNote();
    final note = DataBaseNote.fromRow(notes.first);
    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _noteStremcontrollar.add(_notes);
    return note;
  }

  Future<Iterable<DataBaseNote>> getAlllNotes() async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DataBaseNote.fromRow(noteRow));
  }

  Future<DataBaseNote> updateNote({
    required DataBaseNote note,
    required String text,
  }) async {
    final db = _getDataBaseOrThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {textColumn: text});
    if (updateCount == 0) throw CouldNotUpdateNote();
    return await getNote(id: note.id);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id= ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) throw CouldNotDeleteNoteExciption();
    _notes.removeWhere((note) => note.id == id);
    _noteStremcontrollar.add(_notes);
  }

  Future<int> deleteAllNotes() async {
    final db = _getDataBaseOrThrow();
    return await db.delete(noteTable);
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
