import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CargoEditPage extends StatefulWidget {
  final Map<String, dynamic> cargo;
  const CargoEditPage({super.key, required this.cargo});

  @override
  _CargoEditPageState createState() => _CargoEditPageState();
}

class _CargoEditPageState extends State<CargoEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String description;
  late String cargoType;
  late double weight;

  @override
  void initState() {
    super.initState();
    description = widget.cargo["description"];
    cargoType = widget.cargo["cargoType"];
    weight = widget.cargo["weightTon"];
  }

  Future<void> updateCargo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final res = await http.put(
        Uri.parse("http://10.0.2.2:56976/api/cargoes/${widget.cargo["cargoId"]}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "cargoId": widget.cargo["cargoId"],
          "shipId": widget.cargo["shipId"],
          "description": description,
          "weightTon": weight,
          "cargoType": cargoType,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Güncelleme başarılı")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Güncellenemedi: ${res.statusCode} - ${res.body}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yük Düzenle", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B1E3D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF112A54),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                validator: (v) => v!.isEmpty ? "Açıklama boş olamaz" : null,
                onSaved: (v) => description = v!,
              ),
              TextFormField(
                initialValue: weight.toString(),
                decoration: const InputDecoration(labelText: "Weight (Ton)", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Ağırlık giriniz";
                  if (double.tryParse(v)! <= 0) return "Ağırlık > 0 olmalı";
                  return null;
                },
                onSaved: (v) => weight = double.parse(v!),
              ),
              TextFormField(
                initialValue: cargoType,
                decoration: const InputDecoration(labelText: "Cargo Type", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                validator: (v) => v!.isEmpty ? "Tür boş olamaz" : null,
                onSaved: (v) => cargoType = v!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: updateCargo,
                child: const Text("Güncelle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
