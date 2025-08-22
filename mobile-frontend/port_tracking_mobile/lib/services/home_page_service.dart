import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePageService {
  static const baseUrl = "http://10.0.2.2:56976/api";

  /// JSON'dan gelen listeyi normalize et (List veya $values Map olabilir)
  static List<dynamic> _normalize(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey(r"$values")) return data[r"$values"];
    return [];
  }

  static Future<int> getShipsCount() async {
    final res = await http.get(Uri.parse("$baseUrl/ships"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return _normalize(data).length;
    }
    return 0;
  }

  static Future<int> getPortsCount() async {
    final res = await http.get(Uri.parse("$baseUrl/ports"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return _normalize(data).length;
    }
    return 0;
  }

  static Future<int> getCrewCount() async {
    final res = await http.get(Uri.parse("$baseUrl/crewmembers"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return _normalize(data).length;
    }
    return 0;
  }

  static Future<int> getCargoesCount() async {
    final res = await http.get(Uri.parse("$baseUrl/cargoes"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return _normalize(data).length;
    }
    return 0;
  }

  static Future<int> getAssignmentsCount() async {
    final res = await http.get(Uri.parse("$baseUrl/shipcrewassignments"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return _normalize(data).length;
    }
    return 0;
  }

  static Future<int> getVisitsCount() async {
    final res = await http.get(Uri.parse("$baseUrl/shipcrewassignments"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return _normalize(data).length;
    }
    return 0;
  }
}
