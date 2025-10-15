import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart';

class ProviderCounterPage extends StatelessWidget {
  const ProviderCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounterProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Provider Counter')),
      body: Center(
        child: Text(
          'Count: ${provider.count}',
          style: const TextStyle(fontSize: 28),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
