import 'package:json_annotation/json_annotation.dart';

part 'home_item.g.dart';

@JsonSerializable()
class HomeItem {
  int? id;
  String? title;

  HomeItem({this.id, this.title});

  factory HomeItem.fromJson(Map<String, dynamic> json) =>
      _$HomeItemFromJson(json);

  Map<String, dynamic> toJson() => _$HomeItemToJson(this);
}
