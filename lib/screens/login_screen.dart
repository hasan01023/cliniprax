import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../supabase_config.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final Locale locale;
  final VoidCallback onToggleLanguage;

  const LoginScreen({
    super.key,
    required this.locale,
    required this.onToggleLanguage,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final Map<String, Map<String, String>> _localizedText = {
    'ar': {
      'title': 'كلينيبراكس • الدخول',
      'subtitle': 'منصة OSCE للمحاكاة والتدريب السريري',
      'username': 'اسم المستخدم',
      'password': 'كلمة المرور',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب وربطه بالهاتف',
      'no_account': 'ليس لديك حساب؟ سجل هذا الهاتف الآن',
      'have_account': 'لديك حساب بالفعل؟ سجل دخولك',
      'username_empty': 'يرجى إدخال اسم المستخدم',
      'password_empty': 'يرجى إدخال كلمة المرور',
      'error_username_taken': 'اسم المستخدم هذا محجوز بالفعل لحساب آخر.',
      'error_device_linked': 'عذراً، هذا الهاتف مسجل به حساب آخر بالفعل ولا يمكن تشغيل حسابين من نفس الجهاز.',
      'error_user_not_found': 'اسم المستخدم غير موجود، يرجى التحقق أو التسجيل.',
      'error_wrong_password': 'كلمة المرور غير صحيحة، يرجى إعادة المحاولة.',
      'error_account_linked_elsewhere': 'عذراً، هذا الحساب مرتبط بجهاز آخر بالفعل.',
      'error_device_linked_elsewhere': 'عذراً، هذا الهاتف مرتبِط بحساب آخر بالفعل ولا يمكن تسجيل الدخول بحساب آخر.',
      'success_register': 'تم تسجيل الحساب بنجاح وتم ربطه بهذا الهاتف.',
      'success_login': 'تم تسجيل الدخول بنجاح.',
      'offline_mode_warning': 'أنت تعمل حالياً في وضع عدم الاتصال (محلياً). سيتم حفظ حسابك على هذا الهاتف فقط.',
      'error_general': 'حدث خطأ: ',
    },
    'en': {
      'title': 'Cliniprax • Login',
      'subtitle': 'OSCE Clinical Simulation Platform',
      'username': 'Username',
      'password': 'Password',
      'login': 'Login',
      'register': 'Register & Link to Device',
      'no_account': 'Don\'t have an account? Register this device',
      'have_account': 'Already have an account? Sign In',
      'username_empty': 'Please enter username',
      'password_empty': 'Please enter password',
      'error_username_taken': 'This username is already taken by another account.',
      'error_device_linked': 'Sorry, this phone is already linked to another account.',
      'error_user_not_found': 'Username not found. Please register.',
      'error_wrong_password': 'Incorrect password, please try again.',
      'error_account_linked_elsewhere': 'Sorry, this account is already linked to another device.',
      'error_device_linked_elsewhere': 'Sorry, this phone is already linked to another account. Cannot log in to a different account.',
      'success_register': 'Account registered successfully and linked to this device.',
      'success_login': 'Logged in successfully.',
      'offline_mode_warning': 'You are running in offline mode. Your account will be locked to this device locally.',
      'error_general': 'Error occurred: ',
    }
  };

  String _getTxt(String key) {
    final langCode = widget.locale.languageCode == 'ar' ? 'ar' : 'en';
    return _localizedText[langCode]?[key] ?? key;
  }

  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedId = prefs.getString('device_uuid');
    if (cachedId != null && cachedId.isNotEmpty) {
      return cachedId;
    }

    String deviceId = '';
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }
    } catch (e) {
      debugPrint('Error getting hardware device ID: $e');
    }

    if (deviceId.isEmpty || deviceId == 'unknown') {
      deviceId = 'dev_${DateTime.now().microsecondsSinceEpoch}_${StackTrace.current.hashCode}';
    }

    await prefs.setString('device_uuid', deviceId);
    return deviceId;
  }

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: widget.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final deviceId = await _getDeviceId();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if Supabase is configured
      if (SupabaseConfig.isConfigured && Supabase.instance.client.supabaseUrl.contains('your-project-id') == false) {
        final client = Supabase.instance.client;

        if (_isLoginMode) {
          // --- LOGIN ---
          // 1. Fetch user by username
          final response = await client
              .from('app_users')
              .select()
              .eq('username', username)
              .maybeSingle();

          if (response == null) {
            _showMessage(_getTxt('error_user_not_found'));
            setState(() => _isLoading = false);
            return;
          }

          // 2. Verify password
          if (response['password'] != password) {
            _showMessage(_getTxt('error_wrong_password'));
            setState(() => _isLoading = false);
            return;
          }

          // 3. Verify device binding
          final String? linkedDevice = response['linked_device_id'];

          if (linkedDevice == null || linkedDevice.isEmpty) {
            // First time login for this user: check if this device is already bound to another user
            final deviceMatch = await client
                .from('app_users')
                .select('username')
                .eq('linked_device_id', deviceId)
                .maybeSingle();

            if (deviceMatch != null) {
              _showMessage(_getTxt('error_device_linked_elsewhere'));
              setState(() => _isLoading = false);
              return;
            }

            // Bind user to this device
            await client
                .from('app_users')
                .update({'linked_device_id': deviceId})
                .eq('username', username);
          } else if (linkedDevice != deviceId) {
            // Device does not match
            _showMessage(_getTxt('error_account_linked_elsewhere'));
            setState(() => _isLoading = false);
            return;
          }

          // Check if this device is bound to another user (safety check)
          final deviceMatch = await client
              .from('app_users')
              .select('username')
              .eq('linked_device_id', deviceId)
              .maybeSingle();

          if (deviceMatch != null && deviceMatch['username'] != username) {
            _showMessage(_getTxt('error_device_linked_elsewhere'));
            setState(() => _isLoading = false);
            return;
          }

          // Save session
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('logged_username', username);
          await prefs.setString('linked_device', deviceId);

          _showMessage(_getTxt('success_login'), isError: false);
          _navigateToHome();

        } else {
          // --- REGISTER ---
          // 1. Check if username is taken
          final userCheck = await client
              .from('app_users')
              .select('username')
              .eq('username', username)
              .maybeSingle();

          if (userCheck != null) {
            _showMessage(_getTxt('error_username_taken'));
            setState(() => _isLoading = false);
            return;
          }

          // 2. Check if device is already linked to another user
          final deviceCheck = await client
              .from('app_users')
              .select('username')
              .eq('linked_device_id', deviceId)
              .maybeSingle();

          if (deviceCheck != null) {
            _showMessage(_getTxt('error_device_linked'));
            setState(() => _isLoading = false);
            return;
          }

          // 3. Register user and link device
          await client.from('app_users').insert({
            'username': username,
            'password': password,
            'linked_device_id': deviceId,
          });

          // Save session
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('logged_username', username);
          await prefs.setString('linked_device', deviceId);

          _showMessage(_getTxt('success_register'), isError: false);
          _navigateToHome();
        }
      } else {
        // --- OFFLINE FALLBACK MODE ---
        String? localBoundUser = prefs.getString('local_bound_user');
        String? localBoundPass = prefs.getString('local_bound_pass');

        if (_isLoginMode) {
          if (localBoundUser == null) {
            _showMessage(_getTxt('error_user_not_found') + " (Offline Mode)");
            setState(() => _isLoading = false);
            return;
          }

          if (localBoundUser != username) {
            _showMessage(_getTxt('error_device_linked_elsewhere'));
            setState(() => _isLoading = false);
            return;
          }

          if (localBoundPass != password) {
            _showMessage(_getTxt('error_wrong_password'));
            setState(() => _isLoading = false);
            return;
          }

          // Save session
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('logged_username', username);

          _showMessage(_getTxt('success_login'), isError: false);
          _navigateToHome();
        } else {
          // Register
          if (localBoundUser != null) {
            _showMessage(_getTxt('error_device_linked'));
            setState(() => _isLoading = false);
            return;
          }

          // Save local credentials
          await prefs.setString('local_bound_user', username);
          await prefs.setString('local_bound_pass', password);
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('logged_username', username);

          _showMessage(_getTxt('success_register') + " (Offline Mode)", isError: false);
          _navigateToHome();
        }
      }
    } catch (e) {
      _showMessage(_getTxt('error_general') + e.toString());
      debugPrint('Auth Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          locale: widget.locale,
          onToggleLanguage: widget.onToggleLanguage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = widget.locale.languageCode == 'ar';
    final primaryColor = const Color(0xFF006774);
    final secondaryColor = const Color(0xFF69E8FE);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.08),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Icon / Logo
                    Icon(
                      Icons.security,
                      size: 72,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      _getTxt('title'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      _getTxt('subtitle'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Form fields card
                    Card(
                      elevation: 4,
                      shadowColor: primaryColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Username Input
                            TextFormField(
                              controller: _usernameController,
                              enableInteractiveSelection: false, // Prevents text selection/copying
                              textAlign: isAr ? TextAlign.right : TextAlign.left,
                              decoration: InputDecoration(
                                labelText: _getTxt('username'),
                                labelStyle: TextStyle(color: primaryColor),
                                prefixIcon: Icon(Icons.person, color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return _getTxt('username_empty');
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Password Input
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              enableInteractiveSelection: false, // Prevents text selection/copying
                              textAlign: isAr ? TextAlign.right : TextAlign.left,
                              decoration: InputDecoration(
                                labelText: _getTxt('password'),
                                labelStyle: TextStyle(color: primaryColor),
                                prefixIcon: Icon(Icons.lock, color: primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return _getTxt('password_empty');
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Action Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isLoginMode ? _getTxt('login') : _getTxt('register'),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    // Mode Toggle Button
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoginMode = !_isLoginMode;
                        });
                      },
                      child: Text(
                        _isLoginMode ? _getTxt('no_account') : _getTxt('have_account'),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Language Switcher
                    IconButton(
                      icon: const Icon(Icons.language),
                      color: primaryColor,
                      onPressed: widget.onToggleLanguage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
