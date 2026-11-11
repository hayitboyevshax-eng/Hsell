import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'shell.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _enter(BuildContext c) {
    tabIndex.value = 0;
    Navigator.pushAndRemoveUntil(c, slideRoute(const Shell()), (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: C.bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const SizedBox(height: 16),
              const Text('HSELL', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 2)),
              const SizedBox(height: 8),
              const Text('Xush kelibsiz!', style: T.heading),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(colors: [Color(0xFF2F80ED), Color(0xFF6FB1FC)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: const Stack(alignment: Alignment.center, children: [
                    Positioned(top: 30, left: 30, child: Icon(Icons.phone_iphone, size: 56, color: Colors.white54)),
                    Positioned(top: 50, right: 30, child: Icon(Icons.checkroom, size: 56, color: Colors.white54)),
                    Positioned(bottom: 40, left: 40, child: Icon(Icons.directions_run, size: 56, color: Colors.white54)),
                    Positioned(bottom: 30, right: 40, child: Icon(Icons.blender_outlined, size: 56, color: Colors.white54)),
                    Icon(Icons.shopping_bag_outlined, size: 110, color: Colors.white),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              AppButton('Tizimga kirish', () => Navigator.push(context, slideRoute(const AuthScreen(register: false))), height: 52),
              const SizedBox(height: 12),
              AppButton("Ro'yxatdan o'tish", () => Navigator.push(context, slideRoute(const AuthScreen(register: true))), filled: false, height: 52),
              const SizedBox(height: 12),
              AppButton('Mehmon sifatida kirish', () => _enter(context), filled: false, height: 52),
              const SizedBox(height: 16),
              ListenableBuilder(
                listenable: store,
                builder: (_, __) => DropdownButton<String>(
                  value: store.lang,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: T.body,
                  items: const ["O'zbekcha", 'Русский', 'English']
                      .map((e) => DropdownMenuItem(value: e, child: Text('🌐  $e')))
                      .toList(),
                  onChanged: (v) => store.setLang(v!),
                ),
              ),
            ]),
          ),
        ),
      );
}

class AuthScreen extends StatefulWidget {
  final bool register;
  const AuthScreen({super.key, required this.register});
  @override
  State<AuthScreen> createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  final _name = TextEditingController(), _phone = TextEditingController(), _pass = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _pass.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint, IconData i, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        prefixIcon: Icon(i, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: C.bg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.primary)),
      );

  void _submit() {
    if ((widget.register && _name.text.trim().isEmpty) || _phone.text.trim().length < 9 || _pass.text.length < 4) {
      toast(context, "Maydonlarni to'g'ri to'ldiring");
      return;
    }
    tabIndex.value = 0;
    Navigator.pushAndRemoveUntil(context, slideRoute(const Shell()), (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.register ? "Ro'yxatdan o'tish" : 'Tizimga kirish')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const SizedBox(height: 16),
            if (widget.register) ...[
              TextField(controller: _name, decoration: _dec('Ism familiya', Icons.person_outline)),
              const SizedBox(height: 12),
            ],
            TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: _dec('Telefon: +998 90 123 45 67', Icons.phone_outlined)),
            const SizedBox(height: 12),
            TextField(
              controller: _pass,
              obscureText: _hide,
              decoration: _dec('Parol', Icons.lock_outline,
                  suffix: IconButton(icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20), onPressed: () => setState(() => _hide = !_hide))),
            ),
            const SizedBox(height: 24),
            AppButton(widget.register ? "Ro'yxatdan o'tish" : 'Kirish', _submit, height: 52),
          ]),
        ),
      );
}
