abstract class NewsEvent {}

class FetchTopHeadlines extends NewsEvent {
  final String? category;
  final String? q;
  FetchTopHeadlines({this.category, this.q});
}

class LoadMoreHeadlines extends NewsEvent {
  final String? category;
  final String? q;
  LoadMoreHeadlines({this.category, this.q});
}
