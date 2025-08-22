// lib/services/ship_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShipService {
  static const String baseUrl = "http://10.0.2.2:56976/api/ships";

  // Tüm gemileri getir
  static Future<List<Map<String, dynamic>>> getShips() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    }
    throw Exception("Gemiler yüklenemedi (${res.statusCode})");
  }

  // Yeni gemi ekle
  static Future<void> createShip(Map<String, dynamic> ship) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(ship),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return;
    } else {
      final body = res.body.toLowerCase();
      if (body.contains("duplicate") || body.contains("unique")) {
        throw Exception("Bu IMO numarası zaten kayıtlı!");
      }
      throw Exception("Gemi eklenemedi: ${res.statusCode}");
    }
  }



  // Gemi güncelle
  static Future<void> updateShip(Map<String, dynamic> ship) async {
    final id = ship["shipId"]; // id map'in içinden alınıyor
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(ship),
    );
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Gemi güncellenemedi (${res.statusCode})");
    }
  }

  // Gemi sil
  static Future<void> deleteShip(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Gemi silinemedi (${res.statusCode})");
    }
  }
}
