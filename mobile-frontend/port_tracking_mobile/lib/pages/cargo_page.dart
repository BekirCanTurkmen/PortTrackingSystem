import 'package:flutter/material.dart';

class CargoPage extends StatelessWidget {
  const CargoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yük Yönetimi")),
      body: const Center(child: Text("Burada yük CRUD işlemleri olacak")),
    );
  }
}
