import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import 'users_repository.dart';

class FirebaseUsersRepository implements UsersRepository {
  final FirebaseFirestore _firestore;

  FirebaseUsersRepository(this._firestore);

  @override
  Stream<List<AppUser>> getUsers() {
    return _firestore
        .collection('Users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return AppUser.fromFirestore(
        doc.data(),
        doc.id,
      );
    }).toList());
  }
}
