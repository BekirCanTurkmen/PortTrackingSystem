import 'package:flutter/material.dart';
import '../../services/shipvisit_service.dart';

class ShipVisitPage extends StatefulWidget {
  final Map<String, dynamic>? visit;
  const ShipVisitPage({super.key, this.visit});

  @override
  _ShipVisitPageState createState() => _ShipVisitPageState();
}

class _ShipVisitPageState extends State<ShipVisitPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController shipIdCtrl;
  late TextEditingController portIdCtrl;
  late TextEditingController arrivalCtrl;
  late TextEditingController departureCtrl;
  late TextEditingController purposeCtrl;

  @override
  void initState() {
    super.initState();
    shipIdCtrl =
        TextEditingController(text: widget.visit?["shipId"]?.toString() ?? "");
    portIdCtrl =
        TextEditingController(text: widget.visit?["portId"]?.toString() ?? "");
    arrivalCtrl =
        TextEditingController(text: widget.visit?["arrivalDate"] ?? "");
    departureCtrl =
        TextEditingController(text: widget.visit?["departureDate"] ?? "");
    purposeCtrl =
        TextEditingController(text: widget.visit?["purpose"] ?? "");
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final newVisit = {
      "visitId": widget.visit?["visitId"],
      "shipId": int.tryParse(shipIdCtrl.text) ?? 0,
      "portId": int.tryParse(portIdCtrl.text) ?? 0,
      "arrivalDate": arrivalCtrl.text,
      "departureDate": departureCtrl.text,
      "purpose": purposeCtrl.text,
    };

    if (widget.visit == null) {
      await ShipVisitService.createVisit(newVisit);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ziyaret eklendi")),
      );
    } else {
      await ShipVisitService.updateVisit(newVisit);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ziyaret güncellendi")),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.visit == null ? "Ziyaret Ekle" : "Ziyaret Düzenle"),
        backgroundColor: const Color(0xFF112A54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: shipIdCtrl,
                decoration: const InputDecoration(labelText: "Ship ID"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: portIdCtrl,
                decoration: const InputDecoration(labelText: "Port ID"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: arrivalCtrl,
                decoration: const InputDecoration(labelText: "Arrival Date (yyyy-MM-dd HH:mm)"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              TextFormField(
                controller: departureCtrl,
                decoration: const InputDecoration(labelText: "Departure Date (yyyy-MM-dd HH:mm)"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Zorunlu";
                  if (arrivalCtrl.text.isNotEmpty &&
                      DateTime.tryParse(arrivalCtrl.text) != null &&
                      DateTime.tryParse(v) != null) {
                    final arr = DateTime.parse(arrivalCtrl.text);
                    final dep = DateTime.parse(v);
                    if (dep.isBefore(arr)) {
                      return "Ayrılış tarihi gelişten önce olamaz";
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: purposeCtrl,
                decoration: const InputDecoration(labelText: "Purpose"),
                validator: (v) => v!.isEmpty ? "Zorunlu" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
