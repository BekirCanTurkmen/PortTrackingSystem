import 'package:flutter/material.dart';

class PortPage extends StatelessWidget {
  const PortPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liman Yönetimi")),
      body: const Center(child: Text("Burada liman CRUD işlemleri olacak")),
    );
  }
}
