import 'package:flutter/material.dart';
import '../services/api.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});
  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  String? categoryId;
  final descCtrl = TextEditingController();

  List categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    categories = await Api.get('/categories');
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء طلب خدمة'), actions: [
        IconButton(onPressed: ()=> Navigator.pushNamed(context, '/my'), icon: const Icon(Icons.list))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: categoryId,
              items: categories.map<DropdownMenuItem<String>>((c)=> DropdownMenuItem(value: c['id'], child: Text(c['name']))).toList(),
              onChanged: (v){ setState(()=> categoryId = v); },
              decoration: const InputDecoration(labelText: 'التصنيف'),
            ),
            const SizedBox(height: 8),
            TextField(controller: descCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'وصف المشكلة')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final r = await Api.post('/requests', {
                  'categoryId': categoryId,
                  'description': descCtrl.text,
                });
                if(!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الطلب')));
                Navigator.pushNamed(context, '/my');
              },
              child: const Text('إرسال'),
            )
          ],
        ),
      ),
    );
  }
}
