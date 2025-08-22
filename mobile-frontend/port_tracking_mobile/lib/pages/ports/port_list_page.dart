import 'package:flutter/material.dart';
import '../../services/port_service.dart';
import 'port_create_page.dart';
import 'port_edit_page.dart';

class PortListPage extends StatefulWidget {
  const PortListPage({super.key});

  @override
  _PortListPageState createState() => _PortListPageState();
}

class _PortListPageState extends State<PortListPage> {
  List<dynamic> ports = [];
  List<dynamic> filteredPorts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPorts();
  }

  Future<void> _loadPorts() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final data = await PortService.getPorts();
      if (!mounted) return;
      setState(() {
        ports = data;
        filteredPorts = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> _deletePort(int id) async {
    await PortService.deletePort(id);
    if (!mounted) return;
    _loadPorts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Liman silindi")),
    );
  }

  void _editPort(dynamic port) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PortEditPage(port: port)),
    );
    if (result == true && mounted) _loadPorts();
  }

  void _createPort() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PortCreatePage()),
    );
    if (result == true && mounted) _loadPorts();
  }

  void _searchPort(String query) {
    if (!mounted) return;
    setState(() {
      if (query.isEmpty) {
        filteredPorts = ports;
      } else {
        final lower = query.toLowerCase();
        filteredPorts = ports.where((p) {
          final name = (p["name"] ?? "").toString().toLowerCase();
          final city = (p["city"] ?? "").toString().toLowerCase();
          return name.contains(lower) || city.contains(lower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Limanlar", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B1E3D),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _createPort,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF112A54),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchPort,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Liman adı veya şehir ara...",
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
              itemCount: filteredPorts.length,
              itemBuilder: (context, index) {
                final port = filteredPorts[index];
                return Card(
                  color: const Color(0xFFF8F5FF),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      port["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      "${port["country"]}, ${port["city"]}",
                      style: const TextStyle(color: Colors.black87),
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon:
                          const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editPort(port),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () => _deletePort(port["portId"]),
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
