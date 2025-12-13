import '../models/app_user.dart';

abstract class UsersRepository {
  Stream<List<AppUser>> getUsers();
}
