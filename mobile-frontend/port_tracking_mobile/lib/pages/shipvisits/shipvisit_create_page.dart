import 'package:flutter/material.dart';
import '../../services/shipvisit_service.dart';

class ShipVisitCreatePage extends StatefulWidget {
  const ShipVisitCreatePage({super.key});

  @override
  State<ShipVisitCreatePage> createState() => _ShipVisitCreatePageState();
}

class _ShipVisitCreatePageState extends State<ShipVisitCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController shipIdCtrl = TextEditingController();
  final TextEditingController portIdCtrl = TextEditingController();
  final TextEditingController arrivalCtrl = TextEditingController();
  final TextEditingController departureCtrl = TextEditingController();
  final TextEditingController purposeCtrl = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ShipVisitService.createVisit({
        "shipId": int.tryParse(shipIdCtrl.text),
        "portId": int.tryParse(portIdCtrl.text),
        "arrivalDate": arrivalCtrl.text,
        "departureDate": departureCtrl.text,
        "purpose": purposeCtrl.text,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Ziyaret Ekle", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Gemi ID", shipIdCtrl, TextInputType.number),
              _buildField("Liman ID", portIdCtrl, TextInputType.number),
              _buildField("Geliş Tarihi (yyyy-MM-dd HH:mm)", arrivalCtrl, TextInputType.datetime),
              _buildField("Ayrılış Tarihi (yyyy-MM-dd HH:mm)", departureCtrl, TextInputType.datetime),
              _buildField("Amaç", purposeCtrl, TextInputType.text),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Kaydet", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        validator: (val) => val == null || val.isEmpty ? "$label boş bırakılamaz" : null,
      ),
    );
  }
}
