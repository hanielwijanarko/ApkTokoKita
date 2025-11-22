import 'package:flutter/material.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'package:tokokita/ui/produk_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Login Defit"),   // Sesuai instruksi nama panggilan
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _emailField(),
                const SizedBox(height: 10),
                _passwordField(),
                const SizedBox(height: 20),
                Center(child: _buttonLogin()),
                const SizedBox(height: 20),
                Center(child: _menuRegistrasi()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // TextField Email
  // ===============================
  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: "Email",
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // ===============================
  // TextField Password
  // ===============================
  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password harus diisi';
        }
        return null;
      },
    );
  }

  // ===============================
  // Tombol Login
  // ===============================
  Widget _buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],  
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Setelah valid → masuk ke List Produk
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProdukPage(),
            ),
          );
        }
      },
      child: const Text("Login"),
    );
  }

  Widget _menuRegistrasi() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrasiPage()),
        );
      },
      child: const Text(
        "Registrasi",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
        ),
      ),
    );
  }
}
