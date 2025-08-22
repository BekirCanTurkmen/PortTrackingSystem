import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CargoCreatePage extends StatefulWidget {
  const CargoCreatePage({super.key});

  @override
  _CargoCreatePageState createState() => _CargoCreatePageState();
}

class _CargoCreatePageState extends State<CargoCreatePage> {
  final _formKey = GlobalKey<FormState>();
  String shipId = "";
  String description = "";
  String cargoType = "";
  double weight = 0;

  Future<void> createCargo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final res = await http.post(
        Uri.parse("http://10.0.2.2:56976/api/cargoes"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "shipId": int.parse(shipId),
          "description": description,
          "weightTon": weight,
          "cargoType": cargoType,
        }),
      );

      if (res.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Yük eklenemedi: ${res.body}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Yük Ekle", style: TextStyle(color: Colors.white)),
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
                decoration: const InputDecoration(labelText: "Ship ID", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Gemiyi seçiniz" : null,
                onSaved: (v) => shipId = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                validator: (v) => v!.isEmpty ? "Açıklama giriniz" : null,
                onSaved: (v) => description = v!,
              ),
              TextFormField(
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
                decoration: const InputDecoration(labelText: "Cargo Type", labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                validator: (v) => v!.isEmpty ? "Tür giriniz" : null,
                onSaved: (v) => cargoType = v!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: createCargo,
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
