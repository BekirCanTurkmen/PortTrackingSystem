import 'package:flutter/material.dart';
import '../../services/crew_service.dart';
import 'crew_create_page.dart';
import 'crew_edit_page.dart';

class CrewListPage extends StatefulWidget {
  const CrewListPage({super.key});

  @override
  State<CrewListPage> createState() => _CrewListPageState();
}

class _CrewListPageState extends State<CrewListPage> {
  List<Map<String, dynamic>> crews = [];
  List<Map<String, dynamic>> filteredCrews = [];
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    loadCrew();
  }

  Future<void> loadCrew() async {
    if (!mounted) return;
    setState(() {
      loading = true;
      errorMsg = null;
    });

    try {
      final list = await CrewService.getCrew();
      if (!mounted) return;
      setState(() {
        crews = list.map((e) => e as Map<String, dynamic>).toList();
        filteredCrews = crews;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => errorMsg = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  String formatPhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10 && digits.startsWith("5")) {
      return "+90 ${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 8)} ${digits.substring(8, 10)}";
    } else if (digits.length == 11 && digits.startsWith("05")) {
      return "+90 ${digits.substring(1, 4)} ${digits.substring(4, 7)} ${digits.substring(7, 9)} ${digits.substring(9, 11)}";
    } else if (digits.length == 12 && digits.startsWith("90")) {
      return "+${digits.substring(0, 2)} ${digits.substring(2, 5)} ${digits.substring(5, 8)} ${digits.substring(8, 10)} ${digits.substring(10, 12)}";
    }

    return phone;
  }

  void _searchCrew(String query) {
    if (!mounted) return;
    setState(() {
      if (query.isEmpty) {
        filteredCrews = crews;
      } else {
        final lower = query.toLowerCase();
        filteredCrews = crews.where((c) {
          final fullName =
          "${c["firstName"] ?? ""} ${c["lastName"] ?? ""}".toLowerCase();
          final email = (c["email"] ?? "").toString().toLowerCase();
          final role = (c["role"] ?? "").toString().toLowerCase();
          return fullName.contains(lower) ||
              email.contains(lower) ||
              role.contains(lower);
        }).toList();
      }
    });
  }

  Future<void> _deleteCrew(int id) async {
    try {
      await CrewService.deleteCrew(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mürettebat silindi")),
      );
      loadCrew();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mürettebat"),
        backgroundColor: const Color(0xFF0B1E3D),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CrewCreatePage()),
              );
              if (result == true && mounted) loadCrew();
            },
          )
        ],
      ),
      backgroundColor: const Color(0xFF112A54),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
          ? Center(
          child: Text(errorMsg!,
              style: const TextStyle(color: Colors.red)))
          : Column(
        children: [
          // 🔎 Arama Kutusu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchCrew,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ad, e-posta veya görev ara...",
                hintStyle:
                const TextStyle(color: Colors.white70),
                prefixIcon:
                const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF0B1E3D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredCrews.length,
              itemBuilder: (context, index) {
                final crew = filteredCrews[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${crew["firstName"]} ${crew["lastName"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF0B1E3D),
                          ),
                        ),
                        Text("Görev: ${crew["role"]}"),
                        Text("E-posta: ${crew["email"]}"),
                        Text(
                            "Telefon: ${formatPhoneNumber(crew["phoneNumber"] ?? "")}"),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CrewEditPage(crew: crew),
                                  ),
                                );
                                if (result == true && mounted) {
                                  loadCrew();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () =>
                                  _deleteCrew(crew["crewId"]),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
