import 'package:flutter/material.dart';
import '../../services/port_service.dart';

class PortCreatePage extends StatefulWidget {
  const PortCreatePage({super.key});

  @override
  _PortCreatePageState createState() => _PortCreatePageState();
}

class _PortCreatePageState extends State<PortCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      await PortService.createPort({
        "name": nameCtrl.text,
        "country": countryCtrl.text,
        "city": cityCtrl.text,
      });
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Liman eklendi")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b1e3d),
      appBar: AppBar(
        title: const Text("Yeni Liman", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF112a54),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Liman Adı",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: countryCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Ülke",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: cityCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Şehir",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Kaydet"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
