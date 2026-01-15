import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GANTI DENGAN URL DAN ANON KEY DARI DASHBOARD SUPABASE KAMU
  await Supabase.initialize(
    url: 'https://tpqzbkfjkrqmkcatcspm.supabase.co',
    anonKey: 'sb_publishable_a8UCxf1Ac1PTErIcNzZ2vw_lB0Z8-PS',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPlan',
      debugShowCheckedModeBanner: false, // Hilangkan label debug
      theme: ThemeData(
        useMaterial3: true,
        // Palet Warna Pastel Modern
        scaffoldBackgroundColor: const Color(
          0xFFF7F9FC,
        ), // Background abu sangat muda
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF), // Ungu Pastel Utama
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF81C784), // Hijau Mint lembut
          surface: Colors.white,
        ),

        // Atur Typography (Font)
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),

        // Style Input Text Field Global
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none, // Hilangkan garis border kasar
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),

        // Style Tombol Global
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            elevation: 0, // Flat design (tanpa bayangan kasar)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),

        // Style AppBar Global
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparan
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3142),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Color(0xFF2D3142)),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

// Widget untuk mengecek apakah user sudah login atau belum
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Jika sedang loading session
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Cek apakah ada session aktif
        final session = snapshot.data?.session;
        if (session != null) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
