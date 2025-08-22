import 'package:flutter/material.dart';
import '../../services/crew_service.dart';

class CrewCreatePage extends StatefulWidget {
  const CrewCreatePage({super.key});

  @override
  _CrewCreatePageState createState() => _CrewCreatePageState();
}

class _CrewCreatePageState extends State<CrewCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final roleCtrl = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await CrewService.createCrew({
        "firstName": firstNameCtrl.text,
        "lastName": lastNameCtrl.text,
        "email": emailCtrl.text,
        "phoneNumber": phoneCtrl.text,
        "role": roleCtrl.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mürettebat eklendi")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white38),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Mürettebat"),
        backgroundColor: const Color(0xFF0B1E3D),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: const Color(0xFF112A54),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Ad"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: lastNameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Soyad"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: emailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("E-posta"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Zorunlu";
                  if (!v.contains("@")) return "Geçerli bir e-posta giriniz";
                  return null;
                },
              ),
              TextFormField(
                controller: phoneCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Telefon (5XXXXXXXXX)"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Zorunlu";
                  final regex = RegExp(r'^5\d{9}$');
                  if (!regex.hasMatch(v)) {
                    return "Format: 5XXXXXXXXX olmalı";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: roleCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Görev"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0B1E3D),
                ),
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
