import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';
import '../model/registrasi.dart';

// Events
abstract class RegistrasiEvent {}

class RegistrasiButtonPressed extends RegistrasiEvent {
  final String nama;
  final String email;
  final String password;

  RegistrasiButtonPressed({
    required this.nama,
    required this.email,
    required this.password,
  });
}

// States
abstract class RegistrasiState {}

class RegistrasiInitial extends RegistrasiState {}

class RegistrasiLoading extends RegistrasiState {}

class RegistrasiSuccess extends RegistrasiState {
  final Registrasi registrasi;

  RegistrasiSuccess({required this.registrasi});
}

class RegistrasiFailure extends RegistrasiState {
  final String error;

  RegistrasiFailure({required this.error});
}

// BLoC
class RegistrasiBloc extends Bloc<RegistrasiEvent, RegistrasiState> {
  RegistrasiBloc() : super(RegistrasiInitial()) {
    on<RegistrasiButtonPressed>(_onRegistrasiButtonPressed);
  }

  Future<void> _onRegistrasiButtonPressed(
    RegistrasiButtonPressed event,
    Emitter<RegistrasiState> emit,
  ) async {
    emit(RegistrasiLoading());

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.registrasi),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nama": event.nama,
          "email": event.email,
          "password": event.password,
        }),
      );

      var data = json.decode(response.body);

      if (data['code'] == 200) {
        Registrasi registrasi = Registrasi.fromJson(data);
        emit(RegistrasiSuccess(registrasi: registrasi));
      } else {
        emit(RegistrasiFailure(
            error: data['message'] ?? 'Registrasi gagal'));
      }
    } catch (e) {
      emit(RegistrasiFailure(error: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
