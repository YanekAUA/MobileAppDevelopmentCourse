import 'package:api_request/home/home_list/models/home_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/home_repository.dart';
import '../presentation/home_event.dart';
import '../presentation/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int page = 0;
  List<HomeItem> items = [];

  final HomeRepositoryImpl repository;

  HomeBloc(this.repository) : super(HomeInitialState()) {
    on<FetchPostEvent>((event, emit) async {
      final items = await repository.fetchItems(page);
      this.items = items.data ?? [];
      emit(HomeItemsLoaded(this.items));
    });

    on<LoadMoreEvent>((event, emit) async {
      page++;
      final items = await repository.fetchItems(page);
      this.items.addAll(items.data ?? []);
      emit(HomeItemsLoaded(this.items));
    });
  }
}
