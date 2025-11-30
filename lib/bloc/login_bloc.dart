import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';
import '../helpers/user_info.dart';
import '../model/login.dart';

// Events
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    required this.email,
    required this.password,
  });
}

// States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Login login;

  LoginSuccess({required this.login});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.login),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": event.email,
          "password": event.password,
        }),
      );

      var data = json.decode(response.body);

      if (data['code'] == 200) {
        Login login = Login.fromJson(data);
        // Simpan token
        await UserInfo().setToken(login.token!);
        await UserInfo().setUserID(login.userID.toString());
        emit(LoginSuccess(login: login));
      } else {
        emit(LoginFailure(error: data['message'] ?? 'Login gagal'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }
}