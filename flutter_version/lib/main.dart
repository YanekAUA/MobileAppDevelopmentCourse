import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/core/injection/injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/features/news/presentation/bloc/news_bloc.dart';
import 'src/features/news/presentation/pages/news_list_page.dart';

import 'src/features/news/domain/usecases/get_top_headlines.dart';
import 'src/features/news/presentation/bloc/news_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        final getTopHeadlines = di.di<GetTopHeadlines>();
        return BlocProvider(
          create: (_) => NewsBloc(getTopHeadlines: getTopHeadlines)..add(FetchTopHeadlines()),
          child: const NewsListPage(),
        );
      }),
    );
  }
}
