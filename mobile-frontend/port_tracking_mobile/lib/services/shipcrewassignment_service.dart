import 'dart:convert';
import 'package:http/http.dart' as http;

class ShipCrewAssignmentService {
  static const String baseUrl = "http://10.0.2.2:56976/api/shipcrewassignments";

  // Tüm atamaları getir
  static Future<List<Map<String, dynamic>>> getAssignments() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);

      // Backend’den gelen key isimlerine göre map’leme
      return data.map((e) => {
        "assignmentId": e["assignmentId"],       // int
        "shipId": e["shipId"],                   // int
        "crewId": e["crewId"],                   // int
        "assignmentDate": e["assignmentDate"],   // string (ISO tarih formatında)
      }).toList();
    }
    throw Exception("Atamalar yüklenemedi (${res.statusCode})");
  }

  // Yeni atama ekle
  static Future<void> createAssignment(Map<String, dynamic> assignment) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(assignment),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Atama eklenemedi (${res.statusCode})");
    }
  }

  // Atama güncelle
  static Future<void> updateAssignment(Map<String, dynamic> assignment) async {
    final id = assignment["assignmentId"];
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(assignment),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Atama güncellenemedi (${res.statusCode})");
    }
  }

  // Atama sil
  static Future<void> deleteAssignment(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Atama silinemedi (${res.statusCode})");
    }
  }
}
