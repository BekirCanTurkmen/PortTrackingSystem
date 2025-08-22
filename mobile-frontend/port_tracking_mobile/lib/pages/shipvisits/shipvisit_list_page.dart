import 'package:flutter/material.dart';
import '../../services/shipvisit_service.dart';
import 'shipvisit_create_page.dart';
import 'shipvisit_edit_page.dart';

class ShipVisitListPage extends StatefulWidget {
  const ShipVisitListPage({super.key});

  @override
  State<ShipVisitListPage> createState() => _ShipVisitListPageState();
}

class _ShipVisitListPageState extends State<ShipVisitListPage> {
  List<dynamic> visits = [];
  List<dynamic> filteredVisits = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final data = await ShipVisitService.getVisits();
      if (!mounted) return;
      setState(() {
        visits = data;
        filteredVisits = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _deleteVisit(int id) async {
    try {
      await ShipVisitService.deleteVisit(id);
      if (!mounted) return;
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Silme hatası: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _searchVisit(String query) {
    if (!mounted) return;
    setState(() {
      if (query.isEmpty) {
        filteredVisits = visits;
      } else {
        final lower = query.toLowerCase();
        filteredVisits = visits.where((v) {
          final purpose = (v["purpose"] ?? "").toString().toLowerCase();
          final arrival = (v["arrivalDate"] ?? "").toString().toLowerCase();
          final departure = (v["departureDate"] ?? "").toString().toLowerCase();
          return purpose.contains(lower) ||
              arrival.contains(lower) ||
              departure.contains(lower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2342),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Ziyaretler", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShipVisitCreatePage()),
              );
              if (result == true && mounted) _loadData();
            },
          )
        ],
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchVisit,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Amaç veya tarih ara...",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
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
              itemCount: filteredVisits.length,
              itemBuilder: (context, i) {
                final v = filteredVisits[i];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    title: Text(
                      "ShipId: ${v["shipId"]} • PortId: ${v["portId"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Geliş: ${v["arrivalDate"] ?? "-"}"),
                        Text("Ayrılış: ${v["departureDate"] ?? "-"}"),
                        Text("Amaç: ${v["purpose"] ?? "-"}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                          const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ShipVisitEditPage(visit: v),
                              ),
                            );
                            if (result == true && mounted) _loadData();
                          },
                        ),
                        IconButton(
                          icon:
                          const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteVisit(v["visitId"]),
                        ),
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
