import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/blocs/homework_bloc.dart';
import 'src/router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppRouterDelegate _routerDelegate;
  late final AppRouteInformationParser _routeParser;

  @override
  void initState() {
    super.initState();
    _routerDelegate = AppRouterDelegate();
    _routeParser = AppRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeworkBloc(),
      child: MaterialApp.router(
        title: 'Homework Tracker',
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeParser,
      ),
    );
  }
}
