import 'package:flutter/material.dart';

import '../presenters/grade_presenter.dart';
import '../intents/grade_intent.dart';
import '../core/validators.dart';
import '../core/constants.dart';
import '../repositories/grade_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GradePresenter presenter;
  final _formKey = GlobalKey<FormState>();

  // controllers for non-homework fields
  late final TextEditingController participationController;
  late final TextEditingController presentationController;
  late final TextEditingController mid1Controller;
  late final TextEditingController mid2Controller;
  late final TextEditingController finalController;

  // controllers for homework entries (kept in sync)
  final List<TextEditingController> hwControllers = [];

  @override
  void initState() {
    super.initState();
    // Create repository and presenter
    final repository = GradeRepositoryImpl();
    presenter = GradePresenter(repository);
    final s = presenter.stateNotifier.value;
    participationController = TextEditingController(
      text: s.participation.toString(),
    );
    presentationController = TextEditingController(
      text: s.presentation.toString(),
    );
    mid1Controller = TextEditingController(text: s.midterm1.toString());
    mid2Controller = TextEditingController(text: s.midterm2.toString());
    finalController = TextEditingController(text: s.finalProject.toString());

    _syncHomeworkControllers(s.homeworks.length);
  }

  // Controller synchronization is handled in the builder to avoid
  // races between notifier listeners and widget rebuilds.

  void _syncHomeworkControllers(int desiredLength) {
    while (hwControllers.length < desiredLength) {
      hwControllers.add(TextEditingController(text: '100.0'));
    }
    while (hwControllers.length > desiredLength) {
      hwControllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    presenter.dispose();
    participationController.dispose();
    presentationController.dispose();
    mid1Controller.dispose();
    mid2Controller.dispose();
    finalController.dispose();
    for (final c in hwControllers) {
      c.dispose();
    }
    super.dispose();
  }

  double _parseOrZero(String? s) => parseDoubleOrDefault(s, 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homework Grade Calculator')),
      body: ValueListenableBuilder(
        valueListenable: presenter.stateNotifier,
        builder: (context, state, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  _buildNumericField(
                    'Participation (10%)',
                    participationController,
                    onSaved: (v) => presenter.dispatch(
                      UpdateParticipation(_parseOrZero(v)),
                    ),
                    validator: (v) => percentageFieldValidator(v),
                  ),
                  const SizedBox(height: 8),
                  _buildNumericField(
                    'Presentation (10%)',
                    presentationController,
                    onSaved: (v) =>
                        presenter.dispatch(UpdatePresentation(_parseOrZero(v))),
                    validator: (v) => percentageFieldValidator(v),
                  ),
                  const SizedBox(height: 8),
                  _buildNumericField(
                    'Midterm 1 (15%)',
                    mid1Controller,
                    onSaved: (v) =>
                        presenter.dispatch(UpdateMidterm1(_parseOrZero(v))),
                    validator: (v) => percentageFieldValidator(v),
                  ),
                  const SizedBox(height: 8),
                  _buildNumericField(
                    'Midterm 2 (15%)',
                    mid2Controller,
                    onSaved: (v) =>
                        presenter.dispatch(UpdateMidterm2(_parseOrZero(v))),
                    validator: (v) => percentageFieldValidator(v),
                  ),
                  const SizedBox(height: 8),
                  _buildNumericField(
                    'Final Project (30%)',
                    finalController,
                    onSaved: (v) =>
                        presenter.dispatch(UpdateFinalProject(_parseOrZero(v))),
                    validator: (v) => percentageFieldValidator(v),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Homeworks ($maxHomeworkSlots slots, total ${weightHomeworks.toStringAsFixed(0)}%)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              // Save any currently edited form fields first so
                              // presenter state reflects the user's inputs and
                              // they aren't overwritten when we sync controllers.
                              _formKey.currentState?.save();
                              if (presenter
                                      .stateNotifier
                                      .value
                                      .homeworks
                                      .length >=
                                  maxHomeworkSlots) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Maximum of $maxHomeworkSlots homework slots',
                                    ),
                                  ),
                                );
                                return;
                              }
                              presenter.dispatch(const AddHomework());
                            },
                            tooltip: 'Add homework',
                          ),
                          IconButton(
                            icon: const Icon(Icons.restart_alt),
                            onPressed: () {
                              presenter.dispatch(const ResetHomeworks());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Homeworks reset'),
                                ),
                              );
                            },
                            tooltip: 'Reset homeworks',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Ensure controllers match the current number of homework slots
                  (() {
                    _syncHomeworkControllers(state.homeworks.length);
                    for (var i = 0; i < state.homeworks.length; i++) {
                      final expected = state.homeworks[i].score.toString();
                      if (hwControllers[i].text != expected) {
                        hwControllers[i].text = expected;
                      }
                    }
                    return const SizedBox.shrink();
                  })(),
                  if (state.homeworks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No homework grades yet. Tap + to add up to $maxHomeworkSlots slots.',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ...List.generate(state.homeworks.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildNumericField(
                              'HW ${i + 1}',
                              hwControllers[i],
                              onSaved: (v) => presenter.dispatch(
                                UpdateHomework(i, _parseOrZero(v)),
                              ),
                              validator: (v) => percentageFieldValidator(
                                v,
                                allowEmpty: false,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                presenter.dispatch(RemoveHomework(i)),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              presenter.dispatch(const Calculate());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calculating result...'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.calculate),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('CALCULATE'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          presenter.dispatch(const ResetHomeworks());
                          presenter.dispatch(UpdateParticipation(100.0));
                          presenter.dispatch(UpdatePresentation(100.0));
                          presenter.dispatch(UpdateMidterm1(100.0));
                          presenter.dispatch(UpdateMidterm2(100.0));
                          presenter.dispatch(UpdateFinalProject(100.0));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reset to defaults')),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  if (state.isLoading) const LinearProgressIndicator(),
                  if (state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (state.finalResult != null)
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Final Result: ${state.finalResult!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNumericField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
