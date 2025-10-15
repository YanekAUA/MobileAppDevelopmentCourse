import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/homework.dart';
import '../blocs/homework_bloc.dart';
import '../blocs/homework_event.dart';

class AddHomeworkPage extends StatefulWidget {
  final VoidCallback onSaved;
  const AddHomeworkPage({super.key, required this.onSaved});

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _subjectController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
      return;
    }

    final hw = Homework(
      id: '',
      subject: _subjectController.text.trim(),
      title: _titleController.text.trim(),
      dueDate: _dueDate!,
    );

    context.read<HomeworkBloc>().add(AddHomework(hw));
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Homework')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter subject' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title / Description',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'No date chosen'
                          : 'Due: ${_dueDate!.toLocal().toString().split(' ').first}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Choose Date'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
