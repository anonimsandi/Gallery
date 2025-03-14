// lib/screens/loading_screen.dart
import 'package:flutter/material.dart';
import 'package:gallery_app/view/auth_screen.dart'; // Impor halaman HomeScreen

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // Simulasi proses loading selama 10 detik
    Future.delayed(const Duration(seconds: 10), () {
      // Pindah ke halaman HomeScreen setelah loading selesai
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration:
              const Duration(milliseconds: 500), // Durasi transisi
          pageBuilder: (context, animation, secondaryAnimation) => AuthScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red, // Merah
              Colors.orange, // Oranye
              Colors.yellow, // Kuning
              Colors.green, // Hijau
              Colors.blue, // Biru
              Colors.indigo, // Indigo
              Colors.purple, // Ungu
            ],
            stops: [
              0.0,
              0.15,
              0.3,
              0.45,
              0.6,
              0.75,
              1.0
            ], // Mengatur distribusi warna
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan logo
              Image.asset(
                'assets/images/logo.png', // Path ke gambar logo
                width: 150, // Lebar logo
                height: 150, // Tinggi logo
              ),
              const SizedBox(height: 20),
              // Indikator loading
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              // Teks "Loading..."
              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
