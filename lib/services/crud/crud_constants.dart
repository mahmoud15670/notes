// const dbName = 'notes.db';
// const userTable = 'user';
// const noteTable = 'note';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const createUserTable = '''
// CREATE TABLE IF NOT EXISTS "user" (
// 	"id"	INTEGER NOT NULL,
// 	"email"	TEXT NOT NULL UNIQUE,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
// ''';
// const createNoteTable = '''
// CREATE TABLE IF NOT EXISTS "note" (
// 	"id"	INTEGER NOT NULL,
// 	"user_id"	INTEGER NOT NULL,
// 	"text"	TEXT ,
// 	PRIMARY KEY("id" AUTOINCREMENT),
// 	FOREIGN KEY("user_id") REFERENCES "user"("id")
// );
// ''';
