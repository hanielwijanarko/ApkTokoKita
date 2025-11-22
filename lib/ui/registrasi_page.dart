import 'package:flutter/material.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

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
        title: const Text("Registrasi Defit"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
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
                Center(child: _buttonRegistrasi()),
              ],
            ),
          ),
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

  Widget _buttonRegistrasi() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
        }
      },
      child: const Text("Registrasi"),
    );
  }
}
