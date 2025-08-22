import 'package:flutter/material.dart';
import '../../services/ship_service.dart';
import 'ship_create_page.dart';
import 'ship_edit_page.dart';

class ShipListPage extends StatefulWidget {
  const ShipListPage({super.key});

  @override
  State<ShipListPage> createState() => _ShipListPageState();
}

class _ShipListPageState extends State<ShipListPage> {
  List<dynamic> ships = [];
  List<dynamic> filteredShips = [];
  bool loading = true;

  Future<void> _loadShips() async {
    setState(() => loading = true);
    ships = await ShipService.getShips();
    filteredShips = ships; // başlangıçta hepsini göster
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadShips();
  }

  void _deleteShip(int id) async {
    await ShipService.deleteShip(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gemi silindi")),
    );
    _loadShips();
  }

  void _createShip() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShipCreatePage()),
    );
    if (result == true) _loadShips();
  }

  void _searchShip(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredShips = ships;
      } else {
        final lower = query.toLowerCase();
        filteredShips = ships.where((s) {
          final name = (s["name"] ?? "").toString().toLowerCase();
          final imo = (s["imo"] ?? "").toString().toLowerCase();
          return name.contains(lower) || imo.contains(lower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gemiler"),
        backgroundColor: const Color(0xFF0B1E3D),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _createShip,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF112A54),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔎 Arama Kutusu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchShip,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Gemi adı veya IMO ile ara...",
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
              itemCount: filteredShips.length,
              itemBuilder: (context, i) {
                final s = filteredShips[i];
                return Card(
                  color: const Color(0xFFF8F5FF),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    title: Text(
                      s["name"] ?? "Bilinmeyen",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "IMO: ${s["imo"]}\nTip: ${s["type"]} • ${s["flag"]} (${s["yearBuilt"]})",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShipEditPage(ship: s),
                              ),
                            );
                            if (result == true) _loadShips();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteShip(s["shipId"]),
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
