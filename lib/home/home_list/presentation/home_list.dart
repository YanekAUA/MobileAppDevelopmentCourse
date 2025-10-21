import 'package:api_request/home/home_list/presentation/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/home_bloc.dart';
import '../presentation/home_state.dart';

class HomeListWidget extends StatefulWidget {
  const HomeListWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeListWidgetState();
  }
}

class HomeListWidgetState extends State<HomeListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Dispatch the fetch event once after the first frame instead of on every build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(FetchPostEvent());
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // Reached the bottom of the list
        context.read<HomeBloc>().add(LoadMoreEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        // Fetch event is dispatched in initState to avoid sending it every build
        if (state is HomeItemsLoaded) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              // Wrap ListTile in a Card so it has a Material ancestor
              return Card(
                child: ListTile(title: Text(state.items[index].title ?? "")),
              );
            },
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
