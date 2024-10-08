// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:mynotes/extentions/list/filter.dart';
// import 'package:mynotes/services/crud/crud_constants.dart';
// import 'package:mynotes/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class NotesServices {
//   Database? _db;
//   DataBaseUser? _user;
//   List<DataBaseNote> _notes = [];

//   late final StreamController<List<DataBaseNote>> _noteStremcontrollar;

//   NotesServices._sharedInstance() {
//     _noteStremcontrollar = StreamController<List<DataBaseNote>>.broadcast(
//       onListen: () {
//         _noteStremcontrollar.sink.add(_notes);
//       },
//     );
//   }
//   static final NotesServices _shared = NotesServices._sharedInstance();
//   factory NotesServices() => _shared;

//   Stream<List<DataBaseNote>> get allNotes =>
//       _noteStremcontrollar.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBefore();
//         }
//       });

//   Future<DataBaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUserException {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (_) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAlllNotes();
//     _notes = allNotes.toList();
//     _noteStremcontrollar.add(_notes);
//   }

//   Database _getDataBaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DataBaseNotOpenException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> _ensureDataBaseOpend() async {
//     try {
//       await open();
//     } on DataBaseAlradyOpenExption {
//       //emoty
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DataBaseAlradyOpenExption();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       await db.execute(createUserTable);
//       await db.execute(createNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnAbleToGetDocumentsDirectoryExption();
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DataBaseNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<DataBaseUser> createUser({required String email}) async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();

//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) throw UserAlradyExsitsException();
//     final userId = await db.insert(
//       userTable,
//       {emailColumn: email.toLowerCase()},
//     );
//     return DataBaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<DataBaseUser> getUser({required String email}) async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();
//     final users = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email= ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (users.isEmpty) {
//       throw CouldNotFindUserException();
//     } else {
//       return DataBaseUser.fromRow(users.first);
//     }
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();

//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) throw CouldNotDeleteUserException();
//   }

//   Future<DataBaseNote> createNote({required DataBaseUser owner}) async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();
//     final user = await getUser(email: owner.email);
//     if (user != owner) throw CouldNotFindUserException();
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: '',
//     });
//     final note = DataBaseNote(noteId, owner.id, '');
//     _notes.add(note);
//     _noteStremcontrollar.add(_notes);
//     return note;
//   }

//   Future<DataBaseNote> getNote({required int id}) async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) throw CouldNotFindNote();
//     final note = DataBaseNote.fromRow(notes.first);
//     _notes.removeWhere((note) => note.id == id);
//     _notes.add(note);
//     _noteStremcontrollar.add(_notes);
//     return note;
//   }

//   Future<Iterable<DataBaseNote>> getAlllNotes() async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();
//     final notes = await db.query(noteTable);
//     return notes.map((noteRow) => DataBaseNote.fromRow(noteRow));
//   }

//   Future<DataBaseNote> updateNote({
//     required DataBaseNote note,
//     required String text,
//   }) async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();
//     await getNote(id: note.id);
//     final updateCount = await db.update(noteTable, {textColumn: text},
//         where: 'id = ?', whereArgs: [note.id]);
//     if (updateCount == 0) throw CouldNotUpdateNote();
//     final updatedNote = await getNote(id: note.id);
//     _notes.removeWhere((note) => note.id == updatedNote.id);
//     _notes.add(updatedNote);
//     _noteStremcontrollar.add(_notes);
//     return updatedNote;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id= ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) throw CouldNotDeleteNoteExciption();
//     _notes.removeWhere((note) => note.id == id);
//     _noteStremcontrollar.add(_notes);
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDataBaseOpend();
//     final db = _getDataBaseOrThrow();
//     final deleteNum = await db.delete(noteTable);
//     _notes = [];
//     _noteStremcontrollar.add(_notes);
//     return deleteNum;
//   }
// }

// @immutable
// class DataBaseUser {
//   final int id;
//   final String email;

//   const DataBaseUser({
//     required this.id,
//     required this.email,
//   });

//   DataBaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() {
//     return 'userId = $id and his email = $email';
//   }

//   @override
//   bool operator ==(covariant DataBaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DataBaseNote {
//   final int id;
//   final int userId;
//   final String text;

//   DataBaseNote(
//     this.id,
//     this.userId,
//     this.text,
//   );

//   DataBaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String;
//   @override
//   String toString() {
//     return 'note id = $id and user id = $userId';
//   }

//   @override
//   bool operator ==(covariant DataBaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }
