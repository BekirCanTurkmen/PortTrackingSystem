import 'package:flutter/material.dart';
import '../services/home_page_service.dart';

// 📂 Yeni klasör yapısına göre importlar
import 'ships/ship_list_page.dart';
import 'ports/port_list_page.dart';
import 'crew/crew_list_page.dart';
import 'cargo/cargo_list_page.dart';
import 'assignments/shipcrewassignment_list_page.dart';
import 'shipvisits/shipvisit_list_page.dart'; // ✅ yeni eklendi
import 'login_page.dart'; // ✅ LoginPage import edildi

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int ships = 0, ports = 0, crew = 0, cargoes = 0, assignments = 0, visits = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final s = await HomePageService.getShipsCount();
      final p = await HomePageService.getPortsCount();
      final c = await HomePageService.getCrewCount();
      final cg = await HomePageService.getCargoesCount();
      final a = await HomePageService.getAssignmentsCount();
      final v = await HomePageService.getVisitsCount(); // ✅ yeni eklendi

      setState(() {
        ships = s;
        ports = p;
        crew = c;
        cargoes = cg;
        assignments = a;
        visits = v; // ✅
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  /// 📌 Ortak animasyonlu navigation fonksiyonu
  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // sağdan sola kayma
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          // Fade + Slide aynı anda
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String title, int value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF112A54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF112A54), // koyu mavi arka plan
        title: const Text(
          "Liman Takip Anasayfa",
          style: TextStyle(
            color: Colors.white, // beyaz yazı
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,

        // ✅ Sağ üstte çıkış butonu
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Çıkış Yap",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false, // önceki sayfaları temizle
              );
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    Icons.directions_boat,
                    "Toplam Gemi",
                    ships,
                        () => _navigateWithAnimation(
                        context, const ShipListPage()),
                  ),
                ),
                Expanded(
                  child: _buildStatCard(
                    Icons.anchor,
                    "Liman Sayısı",
                    ports,
                        () => _navigateWithAnimation(
                        context, const PortListPage()),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    Icons.people,
                    "Mürettebat",
                    crew,
                        () => _navigateWithAnimation(
                        context, const CrewListPage()),
                  ),
                ),
                Expanded(
                  child: _buildStatCard(
                    Icons.inventory,
                    "Yükler",
                    cargoes,
                        () => _navigateWithAnimation(
                        context, CargoListPage()),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    Icons.assignment,
                    "Atamalar",
                    assignments,
                        () => _navigateWithAnimation(
                        context, ShipCrewAssignmentListPage()),
                  ),
                ),
                Expanded(
                  child: _buildStatCard(
                    Icons.event_note,
                    "Ziyaretler",
                    visits,
                        () => _navigateWithAnimation(
                        context, ShipVisitListPage()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
