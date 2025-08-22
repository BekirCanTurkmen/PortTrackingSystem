import 'dart:convert';
import 'package:http/http.dart' as http;

class CargoService {
  static const String baseUrl = "http://10.0.2.2:56976/api/cargoes";

  // Tüm yükleri getir
  static Future<List<Map<String, dynamic>>> getCargoes() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    }
    throw Exception("Yükler yüklenemedi (${res.statusCode})");
  }

  // Yeni yük ekle
  static Future<void> createCargo(Map<String, dynamic> cargo) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cargo),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return;
    } else if (res.statusCode == 400 || res.statusCode == 409) {
      throw Exception("Yük eklenemedi: Geçersiz veri veya tekrar kaydı!");
    } else {
      throw Exception("Yük eklenemedi (${res.statusCode})");
    }
  }

  // Yük güncelle
  static Future<void> updateCargo(Map<String, dynamic> cargo) async {
    final id = cargo["cargoId"];
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cargo),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Yük güncellenemedi (${res.statusCode})");
    }
  }

  // Yük sil
  static Future<void> deleteCargo(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Yük silinemedi (${res.statusCode})");
    }
  }
}
