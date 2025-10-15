import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/counter_bloc.dart';
import '../blocs/counter_event.dart';
import '../blocs/counter_state.dart';

class BlocCounterPage extends StatelessWidget {
  const BlocCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Counter')),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) => Text(
            'Count: ${state.count}',
            style: const TextStyle(fontSize: 28),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterBloc>().add(CounterIncremented()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
