import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';
import '../model/produk.dart';

// Events
abstract class ProdukEvent {}

class LoadProduk extends ProdukEvent {}

class CreateProduk extends ProdukEvent {
  final String kodeProduk;
  final String namaProduk;
  final int hargaProduk;

  CreateProduk({
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaProduk,
  });
}

class UpdateProduk extends ProdukEvent {
  final String id;
  final String kodeProduk;
  final String namaProduk;
  final int hargaProduk;

  UpdateProduk({
    required this.id,
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaProduk,
  });
}

class DeleteProduk extends ProdukEvent {
  final String id;

  DeleteProduk({required this.id});
}

// States
abstract class ProdukState {}

class ProdukInitial extends ProdukState {}

class ProdukLoading extends ProdukState {}

class ProdukLoaded extends ProdukState {
  final List<Produk> listProduk;

  ProdukLoaded({required this.listProduk});
}

class ProdukOperationSuccess extends ProdukState {
  final String message;

  ProdukOperationSuccess({required this.message});
}

class ProdukFailure extends ProdukState {
  final String error;

  ProdukFailure({required this.error});
}

// BLoC
class ProdukBloc extends Bloc<ProdukEvent, ProdukState> {
  ProdukBloc() : super(ProdukInitial()) {
    on<LoadProduk>(_onLoadProduk);
    on<CreateProduk>(_onCreateProduk);
    on<UpdateProduk>(_onUpdateProduk);
    on<DeleteProduk>(_onDeleteProduk);
  }

  Future<void> _onLoadProduk(
    LoadProduk event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());

    try {
      final response = await http.get(Uri.parse(ApiUrl.listProduk));
      var data = json.decode(response.body);

      if (data['code'] == 200) {
        List<Produk> listProduk = (data['data'] as List)
            .map((json) => Produk.fromJson(json))
            .toList();
        emit(ProdukLoaded(listProduk: listProduk));
      } else {
        emit(ProdukFailure(error: data['message'] ?? 'Gagal memuat produk'));
      }
    } catch (e) {
      emit(ProdukFailure(error: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> _onCreateProduk(
    CreateProduk event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.createProduk),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "kode_produk": event.kodeProduk,
          "nama_produk": event.namaProduk,
          "harga": event.hargaProduk,
        }),
      );

      var data = json.decode(response.body);

      if (data['code'] == 200) {
        emit(ProdukOperationSuccess(message: 'Produk berhasil ditambahkan'));
        // Reload data after create
        add(LoadProduk());
      } else {
        emit(ProdukFailure(
            error: data['message'] ?? 'Gagal menambahkan produk'));
      }
    } catch (e) {
      emit(ProdukFailure(error: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduk(
    UpdateProduk event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());

    try {
      final response = await http.put(
        Uri.parse(ApiUrl.updateProduk(int.parse(event.id))),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "kode_produk": event.kodeProduk,
          "nama_produk": event.namaProduk,
          "harga": event.hargaProduk,
        }),
      );

      var data = json.decode(response.body);

      if (data['code'] == 200) {
        emit(ProdukOperationSuccess(message: 'Produk berhasil diubah'));
        // Reload data after update
        add(LoadProduk());
      } else {
        emit(ProdukFailure(error: data['message'] ?? 'Gagal mengubah produk'));
      }
    } catch (e) {
      emit(ProdukFailure(error: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduk(
    DeleteProduk event,
    Emitter<ProdukState> emit,
  ) async {
    emit(ProdukLoading());

    try {
      final response = await http.delete(
        Uri.parse(ApiUrl.deleteProduk(int.parse(event.id))),
      );

      var data = json.decode(response.body);

      if (data['data'] == true) {
        emit(ProdukOperationSuccess(message: 'Produk berhasil dihapus'));
        // Reload data after delete
        add(LoadProduk());
      } else {
        emit(ProdukFailure(error: 'Gagal menghapus produk'));
      }
    } catch (e) {
      emit(ProdukFailure(error: 'Terjadi kesalahan: ${e.toString()}'));
    }
  }
}