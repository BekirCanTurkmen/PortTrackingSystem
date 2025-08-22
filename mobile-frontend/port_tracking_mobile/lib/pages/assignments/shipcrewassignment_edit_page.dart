import 'package:flutter/material.dart';
import '../../services/shipcrewassignment_service.dart';

class ShipCrewAssignmentEditPage extends StatefulWidget {
  final Map<String, dynamic> assignment;
  const ShipCrewAssignmentEditPage({super.key, required this.assignment});

  @override
  State<ShipCrewAssignmentEditPage> createState() => _ShipCrewAssignmentEditPageState();
}

class _ShipCrewAssignmentEditPageState extends State<ShipCrewAssignmentEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController shipIdCtrl;
  late TextEditingController crewIdCtrl;
  late TextEditingController dateCtrl;

  @override
  void initState() {
    super.initState();
    shipIdCtrl = TextEditingController(text: widget.assignment["shipId"]?.toString() ?? "");
    crewIdCtrl = TextEditingController(text: widget.assignment["crewId"]?.toString() ?? "");
    dateCtrl = TextEditingController(text: widget.assignment["assignmentDate"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Atama Düzenle", style: TextStyle(color: Colors.white)),
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
                      await ShipCrewAssignmentService.updateAssignment({
                        "assignmentId": widget.assignment["assignmentId"],
                        "shipId": int.tryParse(shipIdCtrl.text),
                        "crewId": int.tryParse(crewIdCtrl.text),
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
