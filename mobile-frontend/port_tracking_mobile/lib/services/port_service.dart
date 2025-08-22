import 'dart:convert';
import 'package:http/http.dart' as http;

class PortService {
  static const String baseUrl = "http://10.0.2.2:56976/api/ports";

  static Future<List<Map<String, dynamic>>> getPorts() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    }
    throw Exception("Limanlar yüklenemedi (${res.statusCode})");
  }

  static Future<void> createPort(Map<String, dynamic> port) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(port),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return;
    } else if (res.statusCode == 400 || res.statusCode == 409) {
      throw Exception("Liman eklenemedi: Geçersiz veri veya tekrar kaydı!");
    } else {
      throw Exception("Liman eklenemedi (${res.statusCode})");
    }
  }

  static Future<void> updatePort(Map<String, dynamic> port) async {
    final id = port["portId"];
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(port),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Liman güncellenemedi (${res.statusCode})");
    }
  }

  static Future<void> deletePort(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Liman silinemedi (${res.statusCode})");
    }
  }
}
