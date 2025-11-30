import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';

class ProdukForm extends StatefulWidget {
  Produk? produk;
  ProdukForm({super.key, this.produk});

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();

  String judul = "Tambah Produk Aulia";
  String tombolSubmit = "Simpan";

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      setState(() {
        judul = "Ubah Produk Aulia";
        tombolSubmit = "Ubah";

        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text =
            widget.produk!.hargaProduk.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.blue,
      ),
      body: BlocListener<ProdukBloc, ProdukState>(
        listener: (context, state) {
          if (state is ProdukOperationSuccess) {
            // Tampilkan dialog sukses
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => SuccessDialog(
                description: state.message,
                okClick: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is ProdukFailure) {
            // Tampilkan dialog error
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => WarningDialog(
                description: state.error,
              ),
            );
          }
        },
        child: BlocBuilder<ProdukBloc, ProdukState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _kodeProdukTextField(),
                      _namaProdukTextField(),
                      _hargaProdukTextField(),
                      const SizedBox(height: 20),
                      if (state is ProdukLoading)
                        const CircularProgressIndicator()
                      else
                        _buttonSubmit(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Kode Produk harus diisi";
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Nama Produk harus diisi";
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Harga harus diisi";
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (widget.produk != null) {
            // Mode UBAH - Trigger UpdateProduk event
            context.read<ProdukBloc>().add(
                  UpdateProduk(
                    id: widget.produk!.id!,
                    kodeProduk: _kodeProdukTextboxController.text,
                    namaProduk: _namaProdukTextboxController.text,
                    hargaProduk:
                        int.parse(_hargaProdukTextboxController.text),
                  ),
                );
          } else {
            // Mode SIMPAN - Trigger CreateProduk event
            context.read<ProdukBloc>().add(
                  CreateProduk(
                    kodeProduk: _kodeProdukTextboxController.text,
                    namaProduk: _namaProdukTextboxController.text,
                    hargaProduk:
                        int.parse(_hargaProdukTextboxController.text),
                  ),
                );
          }
        }
      },
      child: Text(tombolSubmit),
    );
  }
}

// Dialog Success
class SuccessDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const SuccessDialog({Key? key, this.description, this.okClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Berhasil"),
      content: Text(description!),
      actions: [
        ElevatedButton(
          onPressed: () {
            okClick!();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}

// Dialog Warning
class WarningDialog extends StatelessWidget {
  final String? description;

  const WarningDialog({Key? key, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Peringatan"),
      content: Text(description!),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
