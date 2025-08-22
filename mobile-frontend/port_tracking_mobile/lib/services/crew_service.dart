import 'dart:convert';
import 'package:http/http.dart' as http;

class CrewService {
  static const String baseUrl = "http://10.0.2.2:56976/api/crewmembers";

  static Future<List<dynamic>> getCrew() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to load crew");
  }

  static Future<void> createCrew(Map<String, dynamic> crew) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(crew),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception("Failed to create crew");
    }
  }

  static Future<void> updateCrew(int id, Map<String, dynamic> crew) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(crew),
    );
    if (res.statusCode != 204 && res.statusCode != 200) {
      throw Exception("Failed to update crew");
    }
  }

  static Future<void> deleteCrew(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 204 && res.statusCode != 200) {
      throw Exception("Failed to delete crew");
    }
  }
}
