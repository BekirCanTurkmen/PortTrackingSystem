import 'package:flutter/material.dart';
import '../../services/cargo_service.dart';
import 'cargo_create_page.dart';
import 'cargo_edit_page.dart';

class CargoListPage extends StatefulWidget {
  const CargoListPage({super.key});

  @override
  _CargoListPageState createState() => _CargoListPageState();
}

class _CargoListPageState extends State<CargoListPage> {
  List<dynamic> cargoes = [];
  List<dynamic> filteredCargoes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCargoes();
  }

  Future<void> _loadCargoes() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final data = await CargoService.getCargoes();
      if (!mounted) return;
      setState(() {
        cargoes = data;
        filteredCargoes = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> _deleteCargo(int id) async {
    await CargoService.deleteCargo(id);
    if (!mounted) return;
    _loadCargoes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Yük silindi")),
    );
  }

  void _editCargo(dynamic cargo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CargoEditPage(cargo: cargo)),
    );
    if (result == true && mounted) _loadCargoes();
  }

  void _createCargo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CargoCreatePage()),
    );
    if (result == true && mounted) _loadCargoes();
  }

  void _searchCargo(String query) {
    if (!mounted) return;
    setState(() {
      if (query.isEmpty) {
        filteredCargoes = cargoes;
      } else {
        final lower = query.toLowerCase();
        filteredCargoes = cargoes.where((c) {
          final desc = (c["description"] ?? "").toString().toLowerCase();
          final type = (c["cargoType"] ?? "").toString().toLowerCase();
          return desc.contains(lower) || type.contains(lower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yükler", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B1E3D),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _createCargo,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF112A54),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchCargo,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Yük açıklaması veya tip ara...",
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
              itemCount: filteredCargoes.length,
              itemBuilder: (context, index) {
                final cargo = filteredCargoes[index];
                return Card(
                  color: const Color(0xFFF8F5FF),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      cargo["description"] ?? "Tanımsız",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      "Tip: ${cargo["cargoType"]}\nAğırlık: ${cargo["weightTon"]} ton",
                    ),
                    isThreeLine: true,
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon:
                          const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editCargo(cargo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () => _deleteCargo(cargo["cargoId"]),
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
