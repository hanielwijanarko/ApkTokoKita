import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokokita/bloc/login_bloc.dart';
import 'package:tokokita/bloc/registrasi_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();

    if (token != null) {
      setState(() {
        page = const ProdukPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<RegistrasiBloc>(
          create: (context) => RegistrasiBloc(),
        ),
        BlocProvider<ProdukBloc>(
          create: (context) => ProdukBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Toko Kita',
        debugShowCheckedModeBanner: false,
        home: page,
      ),
    );
  }
}
