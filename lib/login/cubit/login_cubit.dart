import 'package:chat_app/response_models/api_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository _userRepository;

  LoginCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginInitial()) {}
  String deviceTokenToSendPushNotification = '';

  signUpWithGoogle() async {
    UserDetail userDetail = UserDetail();
    emit(LoginLoading());
    ApiResponse apiResponse = await _userRepository.authenticateWithGoogle();
    if (apiResponse.success == true) {
      userDetail.email = apiResponse.data!.email!;
      userDetail.id = apiResponse.data!.uid;
      userDetail.deviceToken = deviceTokenToSendPushNotification;
      UserDetail? existingDetail = await _userRepository.checkUser(userDetail.id);
      if (existingDetail == null) {
        bool response = await _userRepository.saveUserDetails(userDetail);
        if (response) {
          print('User save Successfully');
        }
      }
      print("Success Google");
      emit(LoginSuccessful());
    } else {
      emit(ErrorInAuthentication(apiResponse.error ?? "Error"));
    }
  }

  userLogout() async {
    ApiResponse apiResponse = await _userRepository.logout();
    if (apiResponse.success == true) {
      emit(LoggedOut());
    }
  }
}
