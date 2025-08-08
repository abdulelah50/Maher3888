import 'package:flutter/material.dart';
import '../services/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController(text: '0500000000');
  final codeCtrl = TextEditingController(text: '1234');
  String role = 'customer';
  bool sent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if(args != null && args['role'] != null) {
      role = args['role'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role == 'provider' ? 'تسجيل كمزوّد خدمة' : 'تسجيل كمستخدم',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الجوال')),
            const SizedBox(height: 8),
            // Role selector (still editable)
            DropdownButtonFormField(
              value: role,
              items: const [
                DropdownMenuItem(value: 'customer', child: Text('عميل')),
                DropdownMenuItem(value: 'provider', child: Text('مزوّد خدمة')),
              ],
              onChanged: (v){ setState(()=> role = v!); },
              decoration: const InputDecoration(labelText: 'الدور'),
            ),
            const SizedBox(height: 8),
            if(sent) TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'رمز التحقق (1234)')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Api.post('/auth/otp/request', {'phone': phoneCtrl.text});
                      setState(()=> sent = true);
                    },
                    child: const Text('إرسال رمز'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final r = await Api.post('/auth/otp/verify', {'phone': phoneCtrl.text, 'code': codeCtrl.text, 'role': role});
                      Api.token = r['token'];
                      if(role=='customer') {
                        if(!mounted) return;
                        Navigator.pushReplacementNamed(context, '/create');
                      } else {
                        if(!mounted) return;
                        Navigator.pushReplacementNamed(context, '/offers');
                      }
                    },
                    child: const Text('تسجيل الدخول'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
