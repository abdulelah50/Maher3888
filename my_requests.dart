import 'package:flutter/material.dart';
import '../services/api.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});
  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  List list = [];
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    list = await Api.get('/requests/my');
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, i){
          final r = list[i];
          return ListTile(
            title: Text(r['description'] ?? ''),
            subtitle: Text('الحالة: ${r['status']}'),
            trailing: ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/offers', arguments: {'requestId': r['id']});
              },
              child: const Text('العروض'),
            ),
          );
        },
      ),
    );
  }
}
