import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/news/data/datasources/news_remote_datasource.dart';
import '../../features/news/data/repositories/news_repository_impl.dart';
import '../../features/news/domain/repositories/news_repository.dart';
import '../../features/news/domain/usecases/get_top_headlines.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Core
  di.registerLazySingleton(() => DioClient());

  // Data sources
  di.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSource(di<DioClient>()));

  // Repositories
  di.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(remoteDataSource: di<NewsRemoteDataSource>()));

  // Usecases
  di.registerLazySingleton(() => GetTopHeadlines(di<NewsRepository>()));
}
