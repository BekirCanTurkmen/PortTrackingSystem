import 'package:flutter/material.dart';
import '../../services/port_service.dart';

class PortEditPage extends StatefulWidget {
  final Map<String, dynamic> port;

  const PortEditPage({super.key, required this.port});

  @override
  State<PortEditPage> createState() => _PortEditPageState();
}

class _PortEditPageState extends State<PortEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController countryCtrl;
  late TextEditingController cityCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.port["name"]);
    countryCtrl = TextEditingController(text: widget.port["country"]);
    cityCtrl = TextEditingController(text: widget.port["city"]);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await PortService.updatePort({
        "portId": widget.port["portId"],
        "name": nameCtrl.text,
        "country": countryCtrl.text,
        "city": cityCtrl.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Liman güncellendi")),
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
        title: const Text("Liman Düzenle"),
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
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white), // ✨ yazı beyaz
                decoration: _inputDecoration("Liman Adı"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: countryCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Ülke"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: cityCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Şehir"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0B1E3D),
                ),
                child: const Text("Güncelle"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
