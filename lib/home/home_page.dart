import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_4_flutter/home/grade_list/data/grade_repository.dart';
import 'package:homework_4_flutter/home/grade_list/models/grade_list.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_bloc.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_event.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_state.dart';
import 'package:homework_4_flutter/home/grade_list/presentation/grade_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _controllers['participation'] = TextEditingController();
    _controllers['groupPresentation'] = TextEditingController();
    _controllers['midterm1'] = TextEditingController();
    _controllers['midterm2'] = TextEditingController();
    _controllers['finalProject'] = TextEditingController();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateControllersFromState(LoadedGradeState state) {
    _controllers['participation']?.text =
        state.grades['participation']?.toStringAsFixed(0) ?? '100';
    _controllers['groupPresentation']?.text =
        state.grades['groupPresentation']?.toStringAsFixed(0) ?? '100';
    _controllers['midterm1']?.text =
        state.grades['midterm1']?.toStringAsFixed(0) ?? '100';
    _controllers['midterm2']?.text =
        state.grades['midterm2']?.toStringAsFixed(0) ?? '100';
    _controllers['finalProject']?.text =
        state.grades['finalProject']?.toStringAsFixed(0) ?? '100';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GradeBloc(GradeList(), GradeRepository())..add(LoadGradesEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Grade Calculator',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<GradeBloc, GradeState>(
          listener: (context, state) {
            if (state is LoadedGradeState) {
              _updateControllersFromState(state);
            }
          },
          builder: (context, state) {
            if (state is InitialGradeState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LoadedGradeState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFinalGradeDisplay(state.finalGrade),
                    const SizedBox(height: 24),
                    _buildGradeCard(
                      'Participation',
                      '10%',
                      _controllers['participation']!,
                      Icons.person,
                      Colors.blue,
                      (value) => context.read<GradeBloc>().add(
                        UpdateParticipationEvent(value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildHomeworkSection(context, state.homeworks),
                    const SizedBox(height: 16),
                    _buildGradeCard(
                      'Group Presentation',
                      '10%',
                      _controllers['groupPresentation']!,
                      Icons.group,
                      Colors.purple,
                      (value) => context.read<GradeBloc>().add(
                        UpdateGroupPresentationEvent(value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGradeCard(
                      'Midterm 1',
                      '10%',
                      _controllers['midterm1']!,
                      Icons.filter_1,
                      Colors.orange,
                      (value) => context.read<GradeBloc>().add(
                        UpdateMidterm1Event(value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGradeCard(
                      'Midterm 2',
                      '20%',
                      _controllers['midterm2']!,
                      Icons.filter_2,
                      Colors.deepOrange,
                      (value) => context.read<GradeBloc>().add(
                        UpdateMidterm2Event(value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGradeCard(
                      'Final Project',
                      '30%',
                      _controllers['finalProject']!,
                      Icons.assignment,
                      Colors.green,
                      (value) => context.read<GradeBloc>().add(
                        UpdateFinalProjectEvent(value),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }

  Widget _buildGradeCard(
    String title,
    String weight,
    TextEditingController controller,
    IconData icon,
    Color color,
    ValueChanged<double> onChanged,
  ) {
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Weight: $weight',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}$')),
              ],
              onChanged: (text) {
                final value = double.tryParse(text) ?? 0.0;
                onChanged(value);
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
        ],
      ),
    );
  }

  Widget _buildHomeworkSection(BuildContext context, List<double> homeworks) {
    return GradeListWidget(
      grades: homeworks,
      title: 'Homework Assignments',
      onAdd: () => context.read<GradeBloc>().add(AddHomeworkEvent()),
      onRemove: (index) =>
          context.read<GradeBloc>().add(RemoveHomeworkEvent(index)),
      onReset: () => context.read<GradeBloc>().add(ResetHomeworksEvent()),
      onChanged: (index, value) {
        context.read<GradeBloc>().add(UpdateHomeworkEvent(index, value));
      },
    );
  }

  Widget _buildFinalGradeDisplay(double? finalGrade) {
    final grade = finalGrade ?? 0.0;
    Color gradeColor;
    String gradeText;

    if (grade >= 90) {
      gradeColor = Colors.green;
      gradeText = 'A';
    } else if (grade >= 80) {
      gradeColor = Colors.lightGreen;
      gradeText = 'B';
    } else if (grade >= 70) {
      gradeColor = Colors.orange;
      gradeText = 'C';
    } else if (grade >= 60) {
      gradeColor = Colors.deepOrange;
      gradeText = 'D';
    } else {
      gradeColor = Colors.red;
      gradeText = 'F';
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradeColor.withAlpha((255 * 0.1).round()),
            gradeColor.withAlpha((255 * 0.05).round()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gradeColor.withAlpha((255 * 0.3).round()),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Final Grade',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                grade.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 4),
                child: Text(
                  '%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: gradeColor.withAlpha((255 * 0.7).round()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: gradeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Grade: $gradeText',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
