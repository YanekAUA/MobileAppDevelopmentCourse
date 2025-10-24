import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradeListWidget extends StatefulWidget {
  final List<double> grades;
  final String title;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final VoidCallback onReset;
  final void Function(int, double) onChanged;

  const GradeListWidget({
    super.key,
    required this.grades,
    required this.title,
    required this.onAdd,
    required this.onRemove,
    required this.onReset,
    required this.onChanged,
  });

  @override
  State<GradeListWidget> createState() => _GradeListWidgetState();
}

class _GradeListWidgetState extends State<GradeListWidget> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.grades
        .map((grade) => TextEditingController(text: grade.toStringAsFixed(0)))
        .toList();
  }

  @override
  void didUpdateWidget(covariant GradeListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.grades.length != _controllers.length) {
      for (var controller in _controllers) {
        controller.dispose();
      }
      _controllers = widget.grades
          .map((grade) => TextEditingController(text: grade.toStringAsFixed(0)))
          .toList();
    } else {
      for (int i = 0; i < widget.grades.length; i++) {
        if (_controllers[i].text != widget.grades[i].toStringAsFixed(0)) {
          _controllers[i].text = widget.grades[i].toStringAsFixed(0);
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.04).round()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.indigo,
                    ),
                    onPressed: widget.onAdd,
                    tooltip: 'Add Homework',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.orange),
                    onPressed: widget.onReset,
                    tooltip: 'Reset Homeworks',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.grades.isEmpty)
            const Center(
              child: Text(
                'No homeworks added yet.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.grades.length,
              itemBuilder: (context, index) {
                return _buildHomeworkItem(index);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildHomeworkItem(int index) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Homework ${index + 1}',
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
        ),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}$')),
            ],
            onChanged: (text) {
              final value = double.tryParse(text) ?? 0.0;
              widget.onChanged(index, value);
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.indigo, width: 2),
              ),
              suffixText: '%',
              suffixStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: () => widget.onRemove(index),
          tooltip: 'Remove Homework',
        ),
      ],
    );
  }
}
