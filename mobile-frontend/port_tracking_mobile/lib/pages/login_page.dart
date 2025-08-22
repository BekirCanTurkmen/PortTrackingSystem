import 'package:flutter/material.dart';
import '../services/crew_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool loading = false;
  String? errorMsg;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      errorMsg = null;
    });

    try {
      final crewList = await CrewService.getCrew();

      // 🔍 e-posta eşleşmesi
      final user = crewList.firstWhere(
            (c) => c["email"].toString().toLowerCase() == _emailCtrl.text.toLowerCase(),
        orElse: () => {},
      );

      if (user.isEmpty) {
        setState(() => errorMsg = "E-posta ya da şifre  hatalı!");
      } else if (_passCtrl.text.trim() != user["firstName"]) {
        setState(() => errorMsg = "E-posta ya da Şifre hatalı!");
      } else {
        // ✅ başarılı giriş
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() => errorMsg = "Sunucu hatası: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/loginpage.png",
                  height: 100,
                ),

                const SizedBox(height: 16),
                const Text(
                  "Gemi Liman Takip Sistemi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    hintText: "E-posta",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "E-posta zorunlu";
                    }
                    if (!value.contains("@")) {
                      return "Geçerli bir e-posta giriniz";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Şifre ",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Şifre zorunlu" : null,
                ),
                const SizedBox(height: 20),
                if (errorMsg != null)
                  Text(errorMsg!,
                      style: const TextStyle(color: Colors.red, fontSize: 14)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Giriş Yap"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
