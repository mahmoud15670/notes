import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    try {
      final document = await notes.add({
        ownerUserIdField: ownerUserId,
        textField: '',
      });
      final note = await document.get();
      return CloudNote(
        documentId: note.id,
        ownerUserId: ownerUserId,
        text: '',
      );
    } catch (_) {
      throw CouldNotCreateNoteException();
    }
  }

  // Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
  //   try {
  //     return await notes
  //         .where(
  //           ownerUserIdField,
  //           isEqualTo: ownerUserId,
  //         )
  //         .get()
  //         .then(
  //           (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
  //         );
  //   } catch (_) {
  //     throw CouldNotGetAllNoteException();
  //   }
  // }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textField: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
