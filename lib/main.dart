import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/providers/counter_provider.dart';
import 'src/blocs/counter_bloc.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        // BlocProvider is below inside BlocProvider to allow access in subtree
      ],
      child: BlocProvider(
        create: (_) => CounterBloc(),
        child: MaterialApp.router(
          title: 'Navigation2 Counter App',
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeParser,
        ),
      ),
    );
  }
}
