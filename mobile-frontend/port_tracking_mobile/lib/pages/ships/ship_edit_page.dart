import 'package:flutter/material.dart';
import '../../services/ship_service.dart';

class ShipEditPage extends StatefulWidget {
  final Map<String, dynamic> ship;
  const ShipEditPage({Key? key, required this.ship}) : super(key: key);

  @override
  _ShipEditPageState createState() => _ShipEditPageState();
}

class _ShipEditPageState extends State<ShipEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController imoCtrl;
  late TextEditingController typeCtrl;
  late TextEditingController flagCtrl;
  late TextEditingController yearCtrl;

  String? imoError; // ✅ duplicate IMO hatası için
  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.ship["name"] ?? "");
    imoCtrl = TextEditingController(text: widget.ship["imo"] ?? "");
    typeCtrl = TextEditingController(text: widget.ship["type"] ?? "");
    flagCtrl = TextEditingController(text: widget.ship["flag"] ?? "");
    yearCtrl = TextEditingController(
      text: widget.ship["yearBuilt"]?.toString() ?? "",
    );
  }

  Future<void> _saveShip() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        imoError = null;
        loading = true;
      });

      final updatedShip = {
        "shipId": widget.ship["shipId"],
        "name": nameCtrl.text,
        "imo": imoCtrl.text,
        "type": typeCtrl.text,
        "flag": flagCtrl.text,
        "yearBuilt": int.parse(yearCtrl.text),
      };

      try {
        await ShipService.updateShip(updatedShip);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gemi güncellendi")),
        );
        Navigator.pop(context, true);
      } catch (e) {
        if (e.toString().contains("IMO") || e.toString().toLowerCase().contains("duplicate")) {
          setState(() => imoError = "Bu IMO numarası zaten kayıtlı!");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hata: $e")),
          );
        }
      } finally {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      backgroundColor: const Color(0xFF0b1e3d),
      appBar: AppBar(
        title: const Text(
          "Gemi Düzenle",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF112a54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Gemi Adı",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (v) =>
                v == null || v.isEmpty ? "Gemi adı zorunlu" : null,
              ),
              TextFormField(
                controller: imoCtrl,
                decoration: InputDecoration(
                  labelText: "IMO",
                  labelStyle: const TextStyle(color: Colors.white),
                  errorText: imoError,
                ),
                style: const TextStyle(color: Colors.white),
                validator: (v) {
                  if (v == null || v.isEmpty) return "IMO zorunlu";
                  final regex = RegExp(r"^IMO\d{7}$");
                  if (!regex.hasMatch(v)) {
                    return "IMO + 7 rakam girilmeli (örn: IMO1234567)";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: typeCtrl,
                decoration: const InputDecoration(
                  labelText: "Tip",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (v) =>
                v == null || v.isEmpty ? "Tip zorunlu" : null,
              ),
              TextFormField(
                controller: flagCtrl,
                decoration: const InputDecoration(
                  labelText: "Bayrak",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (v) =>
                v == null || v.isEmpty ? "Bayrak zorunlu" : null,
              ),
              TextFormField(
                controller: yearCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "İnşa Yılı",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Yıl zorunlu";
                  final year = int.tryParse(v);
                  if (year == null) return "Geçerli bir yıl giriniz";
                  if (year > currentYear) {
                    return "Yıl $currentYear’den büyük olamaz";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : _saveShip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
