import 'package:flutter/material.dart';
import '../../services/shipcrewassignment_service.dart';

class ShipCrewAssignmentCreatePage extends StatefulWidget {
  const ShipCrewAssignmentCreatePage({super.key});

  @override
  State<ShipCrewAssignmentCreatePage> createState() => _ShipCrewAssignmentCreatePageState();
}

class _ShipCrewAssignmentCreatePageState extends State<ShipCrewAssignmentCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final shipIdCtrl = TextEditingController();
  final crewIdCtrl = TextEditingController();
  final dateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Atama Ekle", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(shipIdCtrl, "Ship Id"),
              const SizedBox(height: 15),
              _buildInput(crewIdCtrl, "Crew Id"),
              const SizedBox(height: 15),
              _buildInput(dateCtrl, "Atama Tarihi (YYYY-AA-GG)", isDate: true),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await ShipCrewAssignmentService.createAssignment({
                        "shipId": int.parse(shipIdCtrl.text),
                        "crewId": int.parse(crewIdCtrl.text),
                        "assignmentDate": dateCtrl.text,
                      });
                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                child: const Text("Kaydet"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String label, {bool isDate = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isDate ? TextInputType.datetime : TextInputType.text,
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
      validator: (v) => v == null || v.isEmpty ? "Boş bırakılamaz" : null,
    );
  }
}
