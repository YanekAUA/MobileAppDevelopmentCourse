import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/homework_bloc.dart';
import '../blocs/homework_state.dart';
import '../blocs/homework_event.dart';

class HomeworkListPage extends StatelessWidget {
  final void Function() onAdd;
  const HomeworkListPage({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homework Tracker')),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          final items = state.items;
          if (items.isEmpty) {
            return const Center(child: Text('No homework tasks yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final hw = items[index];
              return ListTile(
                leading: Checkbox(
                  value: hw.completed,
                  onChanged: (_) => context.read<HomeworkBloc>().add(
                    ToggleHomeworkCompleted(hw.id),
                  ),
                ),
                title: Text(hw.title),
                subtitle: Text(
                  '${hw.subject} • Due ${hw.dueDate.toLocal().toString().split(' ').first}',
                ),
                trailing: hw.completed
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
