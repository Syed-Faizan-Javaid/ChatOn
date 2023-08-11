import 'package:chat_app/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationCubit(this._userRepository) : super(AuthenticationInitial());

  authenticateUser() async {
    bool response = await _userRepository.authenticateUser();
    if (response) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }
}
