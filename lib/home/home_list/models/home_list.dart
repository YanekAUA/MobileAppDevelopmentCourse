import 'package:json_annotation/json_annotation.dart';
import 'home_item.dart';
import 'home_pagination.dart';

part 'home_list.g.dart';

@JsonSerializable()
class HomeList {
  HomePagination? pagination;
  List<HomeItem>? data;

  HomeList({this.pagination, this.data});
  factory HomeList.fromJson(Map<String, dynamic> itemList) =>
      _$HomeListFromJson(itemList);

  Map<String, dynamic> toJson() => _$HomeListToJson(this);
}
