// ship_page.dart
import 'package:flutter/material.dart';
import '../services/ship_service.dart';

class ShipPage extends StatefulWidget {
  final Map<String, dynamic>? ship;
  const ShipPage({super.key, this.ship});

  @override
  _ShipPageState createState() => _ShipPageState();
}

class _ShipPageState extends State<ShipPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController imoCtrl;
  late TextEditingController typeCtrl;
  late TextEditingController flagCtrl;
  late TextEditingController yearCtrl;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.ship?["name"] ?? "");
    imoCtrl = TextEditingController(text: widget.ship?["imo"] ?? "");
    typeCtrl = TextEditingController(text: widget.ship?["type"] ?? "");
    flagCtrl = TextEditingController(text: widget.ship?["flag"] ?? "");
    yearCtrl = TextEditingController(text: widget.ship?["yearBuilt"]?.toString() ?? "");
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final newShip = {
      "shipId": widget.ship?["shipId"],
      "name": nameCtrl.text,
      "imo": imoCtrl.text,
      "type": typeCtrl.text,
      "flag": flagCtrl.text,
      "yearBuilt": int.tryParse(yearCtrl.text) ?? 0,
    };

    setState(() => loading = true);

    try {
      if (widget.ship == null) {
        await ShipService.createShip(newShip);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gemi eklendi")),
        );
      } else {
        await ShipService.updateShip(newShip);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gemi güncellendi")),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ship == null ? "Gemi Ekle" : "Gemi Düzenle"),
        backgroundColor: const Color(0xFF112A54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Gemi Adı"),
                validator: (v) => v == null || v.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: imoCtrl,
                decoration: const InputDecoration(labelText: "IMO"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Zorunlu";
                  if (!v.startsWith("IMO")) return "IMO ile başlamalı";
                  if (v.length != 10) return "IMO 10 karakter olmalı (ör: IMO1234567)";
                  return null;
                },
              ),
              TextFormField(
                controller: typeCtrl,
                decoration: const InputDecoration(labelText: "Tip"),
                validator: (v) => v == null || v.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: flagCtrl,
                decoration: const InputDecoration(labelText: "Bayrak"),
                validator: (v) => v == null || v.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: yearCtrl,
                decoration: const InputDecoration(labelText: "İnşa Yılı"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Zorunlu";
                  final year = int.tryParse(v);
                  if (year == null) return "Geçerli bir yıl girin";
                  if (year > currentYear) return "Yıl ${currentYear}'dan büyük olamaz";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _save,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
