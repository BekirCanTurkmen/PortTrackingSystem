import 'dart:convert';
import 'package:http/http.dart' as http;

class ShipVisitService {
  static const String baseUrl = "http://10.0.2.2:56976/api/shipvisits";

  /// Tüm ziyaretleri getir
  static Future<List<dynamic>> getVisits() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is List) return data;
      if (data is Map && data.containsKey(r"$values")) return data[r"$values"];
      return [];
    }
    throw Exception("Ziyaretler yüklenemedi");
  }

  /// Yeni ziyaret ekle
  static Future<void> createVisit(Map<String, dynamic> visit) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(visit),
    );
    if (res.statusCode != 201) {
      throw Exception("Ziyaret eklenemedi: ${res.statusCode} - ${res.body}");
    }
  }

  /// Ziyaret güncelle
  static Future<void> updateVisit(Map<String, dynamic> visit) async {
    final res = await http.put(
      Uri.parse("$baseUrl/${visit["visitId"]}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(visit),
    );
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Ziyaret güncellenemedi: ${res.statusCode} - ${res.body}");
    }
  }

  /// Ziyaret sil
  static Future<void> deleteVisit(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Ziyaret silinemedi: ${res.statusCode} - ${res.body}");
    }
  }
}
