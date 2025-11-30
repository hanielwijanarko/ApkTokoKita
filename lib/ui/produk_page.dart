import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  void initState() {
    super.initState();
    // Load produk menggunakan BLoC
    context.read<ProdukBloc>().add(LoadProduk());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Produk Aulia"),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                );
                // Reload data setelah tambah
                context.read<ProdukBloc>().add(LoadProduk());
              },
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Logout"),
              trailing: const Icon(Icons.logout),
              onTap: () {
                UserInfo().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: BlocListener<ProdukBloc, ProdukState>(
        listener: (context, state) {
          if (state is ProdukOperationSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProdukFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProdukBloc, ProdukState>(
          builder: (context, state) {
            if (state is ProdukLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProdukLoaded) {
              if (state.listProduk.isEmpty) {
                return const Center(child: Text("Tidak ada produk"));
              }
              return ListView.builder(
                itemCount: state.listProduk.length,
                itemBuilder: (context, index) {
                  return ItemProduk(
                    produk: state.listProduk[index],
                    onUpdate: () {
                      context.read<ProdukBloc>().add(LoadProduk());
                    },
                  );
                },
              );
            } else if (state is ProdukFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${state.error}"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProdukBloc>().add(LoadProduk());
                      },
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback? onUpdate;

  const ItemProduk({super.key, required this.produk, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(produk: produk),
          ),
        );
        if (onUpdate != null) onUpdate!();
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk!),
          subtitle: Text("Rp. ${produk.hargaProduk}"),
        ),
      ),
    );
  }
}
