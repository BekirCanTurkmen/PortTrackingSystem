import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/shipcrewassignment_service.dart';
import 'shipcrewassignment_create_page.dart';
import 'shipcrewassignment_edit_page.dart';

class ShipCrewAssignmentListPage extends StatefulWidget {
  const ShipCrewAssignmentListPage({super.key});

  @override
  _ShipCrewAssignmentListPageState createState() =>
      _ShipCrewAssignmentListPageState();
}

class _ShipCrewAssignmentListPageState
    extends State<ShipCrewAssignmentListPage> {
  List<Map<String, dynamic>> assignments = [];
  List<Map<String, dynamic>> filteredAssignments = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    if (!mounted) return;
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await ShipCrewAssignmentService.getAssignments();
      if (!mounted) return;
      setState(() {
        assignments = data;
        filteredAssignments = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  void _searchAssignment(String query) {
    if (!mounted) return;

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() => filteredAssignments = assignments);
      return;
    }

    final lower = trimmed.toLowerCase();
    final isNumeric = int.tryParse(trimmed) != null;

    setState(() {
      filteredAssignments = assignments.where((a) {
        final shipId = (a["shipId"] ?? "").toString();
        final crewId = (a["crewId"] ?? "").toString();
        final dateStr = (a["assignmentDate"] ?? "").toString();
        final purpose = (a["purpose"] ?? "").toString().toLowerCase();

        // Eğer query sayısal → shipId veya crewId tam eşleşmeli
        if (isNumeric) {
          return shipId == trimmed || crewId == trimmed;
        }

        // Eğer query tarih ile alakalıysa → assignmentDate içinde ara
        if (dateStr.isNotEmpty) {
          try {
            final formatted =
            DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(dateStr));
            if (formatted.toLowerCase().contains(lower)) return true;
          } catch (_) {
            if (dateStr.toLowerCase().contains(lower)) return true;
          }
        }

        // Diğer durumlarda purpose içinde ara
        return purpose.contains(lower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b1e3d),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b1e3d),
        title: const Text(
          "Gemi-Mürettebat Atamaları",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShipCrewAssignmentCreatePage(),
                ),
              );
              if (mounted) loadAssignments();
            },
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : Column(
        children: [
          // 🔎 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchAssignment,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "ShipId, CrewId, tarih veya amaç ara...",
                hintStyle: const TextStyle(color: Colors.white70),
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
              padding: const EdgeInsets.all(8),
              itemCount: filteredAssignments.length,
              itemBuilder: (context, index) {
                final assignment = filteredAssignments[index];
                final dateStr = assignment["assignmentDate"];
                String formattedDate = "Tarih yok";
                if (dateStr != null) {
                  try {
                    formattedDate = DateFormat("yyyy-MM-dd HH:mm")
                        .format(DateTime.parse(dateStr));
                  } catch (_) {
                    formattedDate = dateStr.toString();
                  }
                }

                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 4),
                  child: ListTile(
                    title: Text(
                      "ShipId: ${assignment["shipId"] ?? "-"} - CrewId: ${assignment["crewId"] ?? "-"}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    subtitle: Text(
                      "Tarih: $formattedDate",
                      style:
                      const TextStyle(color: Colors.black54),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShipCrewAssignmentEditPage(
                                      assignment: assignment,
                                    ),
                              ),
                            );
                            if (mounted) loadAssignments();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () async {
                            await ShipCrewAssignmentService
                                .deleteAssignment(
                                assignment["assignmentId"]);
                            if (mounted) loadAssignments();
                          },
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
