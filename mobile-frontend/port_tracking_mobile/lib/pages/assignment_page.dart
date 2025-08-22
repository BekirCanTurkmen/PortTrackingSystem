import 'package:flutter/material.dart';

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Atamalar")),
      body: const Center(
        child: Text("Atamalar listesi burada olacak"),
      ),
    );
  }
}
