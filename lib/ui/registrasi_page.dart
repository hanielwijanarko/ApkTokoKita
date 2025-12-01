import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokokita/bloc/registrasi_bloc.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordKonfirmasiController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Registrasi Haniel"),
      ),
      body: BlocListener<RegistrasiBloc, RegistrasiState>(
        listener: (context, state) {
          if (state is RegistrasiSuccess) {
            // Tampilkan dialog sukses
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is RegistrasiFailure) {
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
        child: BlocBuilder<RegistrasiBloc, RegistrasiState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _namaField(),
                      const SizedBox(height: 10),
                      _emailField(),
                      const SizedBox(height: 10),
                      _passwordField(),
                      const SizedBox(height: 10),
                      _passwordKonfirmasiField(),
                      const SizedBox(height: 20),
                      if (state is RegistrasiLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        Center(child: _buttonRegistrasi()),
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

  
  Widget _namaField() {
    return TextFormField(
      controller: _namaController,
      decoration: const InputDecoration(
        labelText: "Nama",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama harus diisi";
        }
        if (value.length < 3) {
          return "Nama minimal 3 karakter";
        }
        return null;
      },
    );
  }

  
  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email harus diisi";
        }
        return null;
      },
    );
  }


  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        if (value.length < 6) {
          return "Password minimal 6 karakter";
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiField() {
    return TextFormField(
      controller: _passwordKonfirmasiController,
      decoration: const InputDecoration(
        labelText: "Konfirmasi Password",
      ),
      obscureText: true,
      validator: (value) {
        if (value != _passwordController.text) {
          return "Konfirmasi password tidak sama";
        }
        return null;
      },
    );
  }

// Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      child: const Text("Registrasi"),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          // Trigger RegistrasiButtonPressed event
          context.read<RegistrasiBloc>().add(
                RegistrasiButtonPressed(
                  nama: _namaController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              );
        }
      },
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
            Navigator.pop(context);
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
