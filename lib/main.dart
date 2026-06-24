import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_config.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.isConfigured) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
    }
  } else {
    debugPrint('Supabase is not configured yet. Running in offline/static mode.');
  }

  runApp(const ClinipraxApp());
}

class ClinipraxApp extends StatefulWidget {
  const ClinipraxApp({super.key});

  @override
  State<ClinipraxApp> createState() => _ClinipraxAppState();
}

class _ClinipraxAppState extends State<ClinipraxApp> {
  // Global Bilingual Switch State representing lang switcher in React
  Locale _locale = const Locale('ar', 'AE');
  bool _isLoadingSession = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
        _isLoadingSession = false;
      });
    } catch (e) {
      debugPrint('Error checking login status: $e');
      setState(() {
        _isLoadingSession = false;
      });
    }
  }

  void toggleLanguage() {
    setState(() {
      if (_locale.languageCode == 'ar') {
        _locale = const Locale('en', 'US');
      } else {
        _locale = const Locale('ar', 'AE');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliniprax',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
        Locale('en', 'US'),
      ],
      // Fully compliant Material 3 color theme mappings mapping the React palette
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006774),
          primary: const Color(0xFF006774),
          secondary: const Color(0xFF69E8FE),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: _isLoadingSession
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (_isLoggedIn
              ? HomeScreen(
                  locale: _locale,
                  onToggleLanguage: toggleLanguage,
                )
              : LoginScreen(
                  locale: _locale,
                  onToggleLanguage: toggleLanguage,
                )),
    );
  }
}

