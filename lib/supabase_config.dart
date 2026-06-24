// Supabase Database configuration variables for Cliniprax Flutter App

class SupabaseConfig {
  // Replace these with your actual Supabase Project URL and Anon Public Key
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Helper check to determine if Supabase has been properly configured
  static bool get isConfigured {
    return supabaseUrl.isNotEmpty &&
        supabaseUrl != 'YOUR_SUPABASE_URL' &&
        supabaseUrl != 'MY_SUPABASE_URL' &&
        supabaseAnonKey.isNotEmpty &&
        supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY' &&
        supabaseAnonKey != 'MY_SUPABASE_ANON_KEY';
  }
}
