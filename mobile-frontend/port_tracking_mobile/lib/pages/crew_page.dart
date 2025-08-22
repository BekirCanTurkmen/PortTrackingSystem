import 'package:flutter/material.dart';

class CrewPage extends StatelessWidget {
  const CrewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mürettebat Yönetimi")),
      body: const Center(child: Text("Burada mürettebat CRUD işlemleri olacak")),
    );
  }
}
