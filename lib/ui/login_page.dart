import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokokita/bloc/login_bloc.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'package:tokokita/ui/produk_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
        title: const Text("Login Aulia"),   // Sesuai instruksi nama panggilan
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Navigasi ke ProdukPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProdukPage(),
              ),
            );
          } else if (state is LoginFailure) {
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
        child: BlocBuilder<LoginBloc, LoginState>(
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
                      _emailField(),
                      const SizedBox(height: 10),
                      _passwordField(),
                      const SizedBox(height: 20),
                      if (state is LoginLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        Center(child: _buttonLogin()),
                      const SizedBox(height: 20),
                      Center(child: _menuRegistrasi()),
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
          // Trigger LoginButtonPressed event
          context.read<LoginBloc>().add(
                LoginButtonPressed(
                  email: _emailController.text,
                  password: _passwordController.text,
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
