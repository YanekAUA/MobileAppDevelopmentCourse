import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/core/injection/injection.dart' as di;
import 'src/core/util/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/features/news/presentation/bloc/news_bloc.dart';
import 'src/features/news/presentation/pages/news_list_page.dart';

import 'src/features/news/domain/usecases/get_top_headlines.dart';
import 'src/features/news/presentation/bloc/news_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await di.init();
  if ((dotenv.env['NEWS_API_KEY'] ?? '').isEmpty) {
    AppLogger.logger.w(
      'WARNING: NEWS_API_KEY is not set in .env. Create a .env file and add NEWS_API_KEY to use the News API.',
    );
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          final getTopHeadlines = di.di<GetTopHeadlines>();
          return BlocProvider(
            create: (_) =>
                NewsBloc(getTopHeadlines: getTopHeadlines)
                  ..add(FetchTopHeadlines()),
            child: const NewsListPage(),
          );
        },
      ),
    );
  }
}
