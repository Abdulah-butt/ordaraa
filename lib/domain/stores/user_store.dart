import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/app_user.dart';

class UserStore extends Cubit<AppUser> {
  UserStore() : super(AppUser.guest());

  updateUser(AppUser user) {
    emit(user);
  }

  logoutUser() {
    emit(AppUser.guest());
  }
}
