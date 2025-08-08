import 'package:flutter/material.dart';
import '../services/api.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});
  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  String? requestId;
  List offers = [];
  bool providerMode = false;

  final priceCtrl = TextEditingController(text: '100');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    requestId = args != null ? args['requestId'] as String? : null;
    _load();
  }

  Future<void> _load() async {
    if(requestId != null){
      offers = await Api.get('/offers/by-request/$requestId');
      providerMode = false;
    } else {
      // provider browsing open requests to bid on first one
      final list = await Api.get('/requests');
      if(list.isNotEmpty) {
        requestId = list.first['id'];
      }
      providerMode = true;
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(providerMode ? 'لوحة المزود' : 'عروضي')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(providerMode && requestId != null) Text('أقرب طلب مفتوح: $requestId'),
            const SizedBox(height: 8),
            if(providerMode && requestId != null) Row(
              children: [
                Expanded(child: TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعر'))),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await Api.post('/offers', {'requestId': requestId, 'price': double.tryParse(priceCtrl.text) ?? 100});
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال العرض')));
                    _load();
                  },
                  child: const Text('أرسل عرض'),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: offers.length,
                itemBuilder: (ctx, i){
                  final o = offers[i];
                  return ListTile(
                    title: Text('السعر: ${o['price']}'),
                    subtitle: Text('مزود: ${o['providerId']} - الحالة: ${o['status']}'),
                    trailing: !providerMode ? ElevatedButton(
                      onPressed: () async {
                        await Api.post('/offers/${o['id']}/accept', {});
                        if(!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم قبول العرض')));
                      },
                      child: const Text('قبول'),
                    ) : null,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
